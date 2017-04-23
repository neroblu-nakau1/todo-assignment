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
    
    override func clone(_ entity: Entity) -> Entity {
        let ret = super.clone(entity)
        ret.title       = entity.title
        ret.priority    = entity.priority
        ret.date        = entity.date
        ret.notifyDate  = entity.notifyDate
        ret.memo        = entity.memo
        ret.isCompleted = entity.isCompleted
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
