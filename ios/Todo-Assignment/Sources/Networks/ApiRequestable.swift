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
    
    /// APIエンドポイント(ベースURL以下)
    var endpoint: String { get }
    
    /// APIより返却されたJSONを解析して任意のレスポンスに変換する
    /// - parameter json: APIより返却されたSwiftyJSONオブジェクト
    /// - returns: レスポンス
    func parse(_ json: SwiftyJSON.JSON) -> Response?
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { get }
    
    /// パラメータ
    var parameters: [String : Any]? { get }
    
    /// HTTPヘッダ
    var headers: [String : String]? { get }
    
    /// リクエストタイムアウト時間
    var requestTimeoutInterval: TimeInterval? { get }
}

// 非必須メソッド
extension ApiRequestable {
    
    var method: Alamofire.HTTPMethod { return .post }
    
    var parameters: [String : Any]? { return nil }
    
    var headers: [String : String]? { return nil }
    
    var requestTimeoutInterval: TimeInterval? { return nil }
}
