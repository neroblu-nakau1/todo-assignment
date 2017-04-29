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
    typealias Response = [String : JSON]
    
    let task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    /// APIエンドポイント
    var endpoint: String { return "" }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { return .post }
    
    /// パラメータ
//    var parameters: [String : Any]? {
//        return ["zipcode" : self.zipcode]
//    }
    
    /// 解析
    func parse(_ json: SwiftyJSON.JSON) -> Response? {
        return json["data"].dictionaryValue
    }
}
