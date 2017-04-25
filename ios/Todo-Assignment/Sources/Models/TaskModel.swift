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
        case .today:
            return NSPredicate.empty
                //.and(NSPredicate("isCompleted", equal: false))
                .and(NSPredicate("date", equal: Date.today()))
        case .incomplete:
            return NSPredicate.empty
                .and(NSPredicate("isCompleted", equal: false))
        case .completed:
            return NSPredicate.empty
                .and(NSPredicate("isCompleted", equal: true))
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
                sort:      ["priority": true, "id": false, "isCompleted": true,],
                limit:     nil
            )
        }
    }
    
    /// すべてクリアする
    func clearAll() {
        self.entities = [
            [Entity](), // today
            [Entity](), // incomplete
            [Entity](), // completed
        ]
    }
    
    /// 新しいエンティティを生成する
    /// - parameter title: タイトル(タスク名)
    /// - parameter withID: エンティティに与えるID(省略時は自動的に採番)
    /// - returns: 新しいエンティティ
    func create(title: String, withID id: Int64? = nil) -> Entity {
        let ret = self.create(withID: id)
        ret.title = title
        ret.date  = Date.today()
        return ret
    }
    func updateCompleted(_ entity: Entity) {
        self.update(entity) { task, i in
            task.isCompleted = !task.isCompleted
        }
    }
}

// MARK: - App.Model拡張 -
extension App.Model {
    
    /// タスクモデル
    static let Task = TaskModel()
}

extension TaskModel {
    
    func fixture() {
        let titles = ["就職決めたい", "混声合唱がしたい", "検定とりたい", "お金欲しい", "大阪行きたい", "ライブ行きたい", "サッカー見たい", "やせたい", "Wi-Fi欲しい", "パソコン欲しい", "肉食べたい", "ステーキ食べたい", "焼肉食べたい", "車欲しい", "免許取りたい", "まりんと遊びたい", "合唱したい", "ピアノ弾きたい", "自分の部屋欲しい", "寝たい"]
        self.delete(NSPredicate.empty)
        let tasks: [Task] = titles.map {
            let task = self.create(title: $0)
            task.date = Date().zeroClock(addDay: 3)
            return task
        }
        self.insert(tasks)
    }
}
