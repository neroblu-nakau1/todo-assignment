// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// APIリクエストプロトコル
class TestRequest: ApiRequestable {
    
    /// レスポンス
    typealias Response = String
    
    let zipcode: String
    
    init(zipcode: String) {
        self.zipcode = zipcode
    }
    
    /// APIエンドポイント
    var endpoint: String { return "" }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { return .get }
    
    /// パラメータ
//    var parameters: [String : Any]? {
//        return ["zipcode" : self.zipcode]
//    }
    
    ///
    func parse(_ json: SwiftyJSON.JSON) -> Response? {
        
        return json["ip"].stringValue
    }
}
