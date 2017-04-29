// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// タスク取得リクエスト
class GetTaskRequest: ApiRequestable {
    
    /// レスポンス
    typealias Response = [String : JSON]
    
    let zipcode: String
    
    init(zipcode: String) {
        self.zipcode = zipcode
    }
    
    /// APIエンドポイント
    var endpoint: String { return "" }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { return .post }
    
    /// パラメータ
    var parameters: [String : Any]? {
        return ["zipcode" : self.zipcode]
    }
    
    /// 解析
    func parse(_ json: SwiftyJSON.JSON, _ statusCode: Int) -> Response? {
        return json["data"].dictionaryValue
    }
}
