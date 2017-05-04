// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// タスク削除APIリクエスト
class DeleteTaskRequest: ApiRequestable {
    
    /// レスポンス
    typealias Response = Bool
    
    /// サーバ識別子の配列
    let serverIdentifiers: [String]
    
    /// イニシャライザ
    /// - parameter serverIdentifiers: サーバ識別子の配列
    init(serverIdentifiers: [String]) {
        self.serverIdentifiers = serverIdentifiers
    }
    
    /// イニシャライザ
    /// - parameter task: タスク
    convenience init(task: Task) {
        self.init(serverIdentifiers: [task.serverIdentifier])
    }
    
    /// APIエンドポイント
    var endpoint: String {
        let identifier = (self.serverIdentifiers as NSArray).componentsJoined(by: ",")
        return "tasks/\(identifier)"
    }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { return .delete }
    
    /// 解析
    func parse(_ json: SwiftyJSON.JSON, _ statusCode: Int) -> Response? {
        if (statusCode != 200) {
            print("\(statusCode): \(self.parseMessage(json))")
            return false
        }
        return true
    }
}
