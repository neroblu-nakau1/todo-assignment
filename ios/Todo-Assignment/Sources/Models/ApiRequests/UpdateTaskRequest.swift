// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// タスク更新APIリクエスト
class UpdateTaskRequest: ApiRequestable {
    
    /// レスポンス
    typealias Response = Bool
    
    /// タスク
    let task: Task
    
    /// イニシャライザ
    /// - parameter task: タスク
    init(task: Task) {
        self.task = task
    }
    
    /// APIエンドポイント
    var endpoint: String { return "tasks/\(self.task.serverIdentifier)" }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { return .put }
    
    /// パラメータ
    var parameters: [String : Any]? {
        return [
            "title"        : self.task.title,
            "date"         : self.task.date.parameterString,
            "priority"     : self.task.priority,
            "memo"         : self.task.memo,
            "is_completed" : self.task.isCompleted,
        ]
    }
    
    /// 解析
    func parse(_ json: SwiftyJSON.JSON, _ statusCode: Int) -> Response? {
        if (statusCode != 200) {
            print("\(statusCode): \(self.parseMessage(json))")
            return false
        }
        App.Model.Task.updateSynced(self.task)
        return true
    }
}
