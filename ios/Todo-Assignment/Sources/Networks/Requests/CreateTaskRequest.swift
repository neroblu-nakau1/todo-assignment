// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// タスク作成リクエスト
class CreateTaskRequest: ApiRequestable {
    
    /// レスポンス
    typealias Response = Bool
    
    let task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    /// APIエンドポイント
    var endpoint: String { return "tasks" }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { return .post }
    
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
        if (statusCode != 201) { // 201 = Created
            print("\(statusCode): \(self.parseMessage(json))")
            return false
        }
        else if let identifier = json["data"]["identifier"].string {
            App.Model.Task.updateServerIdentifier(self.task, to: identifier)
            return true
        }
        return false
    }
}
