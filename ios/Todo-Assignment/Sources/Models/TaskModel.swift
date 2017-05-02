// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

enum TaskSegment: Int {
    case today
    case incomplete
    case completed
    
    static let count = 3
    
    var predicate: NSPredicate {
        let prd = NSPredicate("isDeleted", equal: false)
        switch self {
        case .today:      return prd.and(NSPredicate("date",        equal: Date.today()))
        case .incomplete: return prd.and(NSPredicate("isCompleted", equal: false))
        case .completed:  return prd.and(NSPredicate("isCompleted", equal: true))
        }
    }
}

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
        for i in 0..<TaskSegment.count {
            let segment = TaskSegment(rawValue: i)
            self.entities[i] = self.select(
                condition: segment?.predicate,
                sort:      ["priority": .asc, "id": .desc, "isCompleted": .asc],
                limit:     nil
            )
        }
    }
    
    func fetchUnsyncedInsertEntities() -> [Entity] {
        let condition = NSPredicate.empty
            .and(NSPredicate("serverIdentifier", equal: ""))
            .and(NSPredicate("isDeleted", equal: false))
            .and(NSPredicate("isSynced", equal: false))
        return self.select(condition: condition)
    }
    
    func fetchUnsyncedUpdateEntities() -> [Entity] {
        let condition = NSPredicate.empty
            .and(NSPredicate("serverIdentifier", notEqual: ""))
            .and(NSPredicate("isDeleted", equal: false))
            .and(NSPredicate("isSynced", equal: false))
        return self.select(condition: condition)
    }
    
    func fetchUnsyncedDeleteEntities() -> [Entity] {
        let condition = NSPredicate.empty
            .and(NSPredicate("serverIdentifier", notEqual: ""))
            .and(NSPredicate("isDeleted", equal: true))
            .and(NSPredicate("isSynced", equal: false))
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
    
    override func update(_ entity: Task, updating: (Task) -> Void) {
        super.update(entity) { task in
            task.isSynced = false
            updating(task)
        }
        App.API.request(UpdateTaskRequest(task: entity)) { _, _ in }
    }
    
    /// サーバ識別子を更新する
    /// - parameter entity: 対象のタスク
    /// - parameter identifier: サーバ識別子
    func updateServerIdentifier(_ entity: Entity, to identifier: String) {
        super.update(entity) { task in
            task.serverIdentifier = identifier
            task.isSynced = true
        }
    }
    
    /// サーバ識別子を更新する
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
        self.deleteNotify(entity)
        super.update(entity) { task in
            task.isDeleted = true
        }
        App.API.request(DeleteTaskRequest(task: entity)) { response, result in
            if result.ok {
                super.delete(entity)
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
        
        // syncIds: サーバと同期してから削除するタスク, noSyncIds: サーバとの同期が必要のないタスク
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
                if result.ok {
                    super.delete(ids: syncIds)
                }
            }
        }
        
        // noSyncIdsの削除
        super.delete(ids: noSyncIds)
    }
}

// MARK: - App.Model拡張 -
extension App.Model {
    
    /// タスクモデル
    static let Task = TaskModel()
}

extension TaskModel {
    
    func fixture() {
        let titles = [
            "就職決めたい", "混声合唱がしたい", "検定とりたい", "お金欲しい",
            "大阪行きたい", "ライブ行きたい", "サッカー見たい", "やせたい", "Wi-Fi欲しい",
            "パソコン欲しい", "肉食べたい", "ステーキ食べたい", "焼肉食べたい", "車欲しい", "免許取りたい",
            "まりんと遊びたい", "合唱したい", "ピアノ弾きたい", "自分の部屋欲しい", "寝たい"
        ]
        self.delete(condition: NSPredicate.empty)
        let tasks: [Task] = titles.map {
            let task = self.create(title: $0)
            task.date = Date().zeroClock(addDay: Int.random(min: 0, max: 3))
            return task
        }
        self.insert(tasks)
    }
}
