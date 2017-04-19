// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// APIリクエストプロトコル
protocol ApiRequestable {
    
    /// レスポンス
    associatedtype Response
    
    /// APIエンドポイント
    var endpoint: String { get }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { get }
    
    /// パラメータ
    var parameters: [String : Any]? { get }
    
    /// HTTPヘッダ
    var headers: [String : String]? { get }
    
    /// リクエストタイムアウト時間
    var requestTimeoutInterval: TimeInterval? { get }
    
    /// 
    func parse(_ json: SwiftyJSON.JSON) -> Response?
}

// Not-Required
extension ApiRequestable {
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var requestTimeoutInterval: TimeInterval? {
        return nil
    }
}
