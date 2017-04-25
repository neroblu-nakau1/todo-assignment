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
        let titles = ["会う", "合う", "遭う", "飽かす", "明かす", "挙がる", "上がる", "揚がる", "飽きる", "開く", "空く", "明く", "開ける", "揚げる", "空ける", "明ける", "挙げる", "上げる", "当たる", "充てる", "当てる", "浴びせる", "浴びる", "荒らす", "在る", "有る", "荒れる", "合わす", "合わせる", "仰ぐ", "赤らむ", "明らむ", "赤らめる", "明るむ", "商う", "欺く", "味わう", "預かる", "預ける", "焦る", "遊ぶ", "与える", "温まる", "暖まる", "緩める", "温める", "暖める", "集まる", "集める"]
        self.delete(NSPredicate.empty)
        let tasks: [Task] = titles.map {
            let task = self.create(title: $0)
            //task.date = Date().zeroClock(addDay: 3)
            return task
        }
        self.insert(tasks)
    }
}
