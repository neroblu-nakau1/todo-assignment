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
        switch self {
        case .today:      return NSPredicate("date",        equal: Date.today())
        case .incomplete: return NSPredicate("isCompleted", equal: false)
        case .completed:  return NSPredicate("isCompleted", equal: true)
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
    
    /// 新しいタスクを生成する
    /// - parameter title: タスク名(タイトル)
    /// - returns: 新しいタスク
    func create(title: String) -> Entity {
        let ret = self.create()
        ret.title = title
        ret.date  = Date.today()
        return ret
    }
    
    /// 通知を更新する
    /// - parameter entity: 対象のタスク
    /// - parameter date: 通知時刻
    func updateNotify(_ entity: Entity, to date: Date?) {
        self.deleteNotify(entity)
        self.update(entity) { task in
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
        super.delete(entity)
    }
    
    /// 指定した複数のIDに該当するエンティティを削除する
    /// - parameter ids: IDの配列
    override func delete(ids: [Int]) {
        let notifications = self.select(ids: ids).flatMap { $0.notify }
        App.Model.LocalNotification.delete(notifications)
        super.delete(ids: ids)
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
            task.date = Date().zeroClock(addDay: Int.random(min: 0, max: 7))
            return task
        }
        self.insert(tasks)
    }
}
