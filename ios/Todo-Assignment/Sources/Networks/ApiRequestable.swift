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
    /// - parameter statusCode: ステータスコード
    /// - returns: レスポンス
    func parse(_ json: SwiftyJSON.JSON, _ statusCode: Int) -> Response?
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { get }
    
    /// パラメータ
    var parameters: [String : Any]? { get }
    
    /// HTTPヘッダ
    var headers: [String : String]? { get }
}

extension ApiRequestable {
    
    /// トークンの解析処理
    /// - parameter json: APIより返却されたSwiftyJSONオブジェクト
    func parseToken(_ json: SwiftyJSON.JSON) {
        if let token = json["token"].string {
            App.Model.Keychain.token = token
        }
    }
    
    func parseMessage(_ json: SwiftyJSON.JSON) -> String {
        return json["message"].stringValue
    }
}

// 非必須メソッド
extension ApiRequestable {
    
    var method: Alamofire.HTTPMethod { return .post }
    
    var parameters: [String : Any]? { return nil }
    
    var headers: [String : String]? { return ["X-TodoApp-User-Token" : App.Model.Keychain.token] }
}

// MARK: - Date拡張 -
extension Date {
    
    /// APIのパラメータ用文字列
    var parameterString: String {
        return self.formattedString("YYYY-MM-dd")
    }
}
