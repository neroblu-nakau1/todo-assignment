// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - タスク一覧の種類(セグメントコントロールのアイテム) -

enum TaskSegment: Int {
    case today
    case incomplete
    case completed
    
    var predicate: NSPredicate {
        let prd = NSPredicate("isDeleted", equal: false)
        switch self {
        case .today:      return prd.and(NSPredicate("date",        equal: Date.today()))
        case .incomplete: return prd.and(NSPredicate("isCompleted", equal: false))
        case .completed:  return prd.and(NSPredicate("isCompleted", equal: true))
        }
    }
    
    static var items: [TaskSegment] { return [.today, .incomplete, .completed] }
}

// MARK: - タスクエンティティモデル -

class TaskModel: RealmModel<Task> {
    
    static let minimumPriority = 1
    static let maximumPriority = 4
    
    fileprivate(set) var entities = [
        [Entity](), // today
        [Entity](), // incomplete
        [Entity](), // completed
    ]
    
    /// すべてを読み込む
    func loadAll() {
        let sort: RealmSort = [
            "id":          .orderedDescending,
            "isCompleted": .orderedAscending,
            "date":        .orderedAscending,
            "priority":    .orderedDescending
        ]
        
        self.entities = TaskSegment.items.map {
            self.select(
                condition: $0.predicate,
                sort:      sort,
                limit:     nil
            )
        }
    }
    
    /// サーバ同期されていないタスクを条件にもとづいて抽出して配列で返す
    /// - parameter serverIdentifierIsEmpty:
    ///     - true:  serverIdentifierが空のもののみを抽出
    ///     - false: serverIdentifierが空でないもののみを抽出
    /// - parameter isDeleted: 削除フラグ
    /// - returns: 抽出された同期されていないタスクの配列
    func fetchUnsyncedEntities(serverIdentifierIsEmpty: Bool, isDeleted: Bool) -> [Entity] {
        var condition = NSPredicate.empty
            .and(NSPredicate("isDeleted", equal: isDeleted))
            .and(NSPredicate("isSynced", equal: false))
        
        condition = serverIdentifierIsEmpty ?
            condition.and(NSPredicate("serverIdentifier", equal:    "")) :
            condition.and(NSPredicate("serverIdentifier", notEqual: ""))
        
        return self.select(condition: condition)
    }
        
    /// 新しいタスクを生成する
    /// - parameter title: タスク名(タイトル)
    /// - returns: 新しいタスク
    func create(title: String) -> Entity {
        let ret = self.create()
        ret.title = title
        ret.date  = Date.today()
        return ret
    }
    
    /// 新しくタスクを追加保存する
    /// - parameter entity: 対象のタスク
    func add(_ entity: Entity) {
        super.save(entity)
        App.API.request(CreateTaskRequest(task: entity)) { _, _ in }
    }
    
    /// タスクを更新する
    /// - parameter entity: 対象のタスク
    /// - parameter updating: データ更新クロージャ
    override func update(_ entity: Task, updating: (Task) -> Void) {
        super.update(entity) { task in
            task.isSynced = false
            updating(task)
        }
        App.API.request(UpdateTaskRequest(task: entity)) { _, _ in }
    }
    
    /// サーバ識別子を更新する (サーバ同期が終わったら呼び出す) => 同期フラグも併せてtrueに更新
    /// - parameter entity: 対象のタスク
    /// - parameter identifier: サーバ識別子
    func updateServerIdentifier(_ entity: Entity, to identifier: String) {
        super.update(entity) { task in
            task.serverIdentifier = identifier
            task.isSynced = true
        }
    }
    
    /// 同期フラグをtrueに更新する
    /// - parameter entity: 対象のタスク
    func updateSynced(_ entity: Entity) {
        super.update(entity) { task in
            task.isSynced = true
        }
    }
    
    /// 通知を更新する
    /// - parameter entity: 対象のタスク
    /// - parameter date: 通知時刻
    func updateNotify(_ entity: Entity, to date: Date?) {
        self.deleteNotify(entity)
        super.update(entity) { task in // サーバへの同期は行わないため親メソッドを呼んでいる
            task.notify = App.Model.LocalNotification.create(task: entity, date: date)
        }
    }
    
    /// 現在セットしている通知を削除する
    /// - parameter entity: 対象のタスク
    func deleteNotify(_ entity: Entity) {
        if let currentNotify = entity.notify {
            App.Model.LocalNotification.delete(currentNotify)
        }
    }
    
    /// 指定したエンティティを削除する
    /// - parameter entity: エンティティ
    override func delete(_ entity: Task) {
        // 論理削除
        self.deleteNotify(entity)
        super.update(entity) { task in
            task.isDeleted = true
        }
        App.API.request(DeleteTaskRequest(task: entity)) { response, _ in
            // API処理が正常に終わったら物理削除
            if (response ?? false) {
                self.drop(entity)
            }
        }
    }
    
    /// 指定した複数のIDに該当するエンティティを削除する
    /// - parameter ids: IDの配列
    override func delete(ids: [Int]) {
        let targetTasks = self.select(ids: ids)
        let notifications = targetTasks.flatMap { $0.notify }
        App.Model.LocalNotification.delete(notifications)
        super.update(targetTasks) { task, i in
            task.isDeleted = true
        }
        
        // syncIds:   サーバと同期してから削除する必要があるタスク
        // noSyncIds: サーバとの同期が必要のないタスク
        var serverIdentifiers = [String](), syncIds = [Int](), noSyncIds = [Int]()
        targetTasks.forEach { task in
            if (!task.serverIdentifier.isEmpty) {
                syncIds.append(task.id)
                serverIdentifiers.append(task.serverIdentifier)
            } else {
                noSyncIds.append(task.id)
            }
        }
        
        // syncIdsの削除
        if !syncIds.isEmpty {
            App.API.request(DeleteTaskRequest(serverIdentifiers: serverIdentifiers)) { response, result in
                // API処理が正常に終わったら物理削除
                if result.ok {
                    self.drop(ids: syncIds)
                }
            }
        }
        
        // noSyncIdsの削除
        self.drop(ids: noSyncIds)
    }
    
    /// 指定したエンティティを物理削除する
    /// - parameter entity: エンティティ
    func drop(_ entity: Task) {
        super.delete(entity)
    }
    
    /// 指定した複数のIDに該当するエンティティを物理削除する
    /// - parameter ids: IDの配列
    func drop(ids: [Int]) {
        super.delete(ids: ids)
    }
    
    /// 指定した複数のサーバ識別子に該当するエンティティを物理削除する
    /// - parameter serverIdentifiers: サーバ識別子の配列
    func drop(serverIdentifiers: [String]) {
        super.delete(condition: NSPredicate("serverIdentifier", valuesIn: serverIdentifiers))
    }
}

// MARK: - App.Model拡張 -
extension App.Model {
    
    /// タスクエンティティモデル
    static let Task = TaskModel()
}

// MARK: - TaskModel拡張 -
extension TaskModel {
    
    func fixture() {
        let titles = [
            "家賃を払う", "書籍を購入する", "検定の申込みをする", "振込をする",
            "東京行きの新幹線チケットを買う", "ライブのチケット予約をする", "サッカーのチケットを買う", "ジムの予約をする", "見積もりを書く",
            "パソコンを買う", "田中さんに電話をする", "牛肉180gを買う", "大根を買う", "牛乳を買う",
            "店の予約をする", "内科に行く", "耳鼻科に行く", "コーヒー豆を買う",
        ]
        self.delete(condition: NSPredicate.empty)
        let tasks: [Task] = titles.map {
            let task = self.create(title: $0)
            task.date = Date().zeroClock(addDay: Int.random(min: 0, max: 5))
            return task
        }
        self.insert(tasks)
    }
}
