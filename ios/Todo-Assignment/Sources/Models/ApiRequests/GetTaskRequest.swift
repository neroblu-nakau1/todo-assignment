// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// タスク取得APIリクエスト
class GetTaskRequest: ApiRequestable {
    
    /// レスポンス
    typealias Response = [String : JSON]
    
    /// APIエンドポイント
    var endpoint: String { return "tasks" }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { return .post }
    
    /// 解析
    func parse(_ json: SwiftyJSON.JSON, _ statusCode: Int) -> Response? {
        return json["data"].dictionaryValue
    }
}
