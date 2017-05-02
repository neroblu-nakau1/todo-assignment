// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// タスク削除リクエスト
class DeleteTaskRequest: ApiRequestable {
    
    /// レスポンス
    typealias Response = Bool
    
    let serverIdentifiers: [String]
    
    init(serverIdentifiers: [String]) {
        self.serverIdentifiers = serverIdentifiers
    }
    
    convenience init(task: Task) {
        self.init(serverIdentifiers: [task.serverIdentifier])
    }
    
    /// APIエンドポイント
    var endpoint: String {
        let identifier = self.serverIdentifiers.reduce("") { $0 + "," + $1 }
        return "?identifier=\(identifier)"
    }
    
    /// APIメソッド(HTTPメソッド)
    var method: Alamofire.HTTPMethod { return .delete }
    
    /// 解析
    func parse(_ json: SwiftyJSON.JSON, _ statusCode: Int) -> Response? {
        print(json.rawString())
        if (statusCode != 200) {
            print("\(statusCode): \(self.parseMessage(json))")
            return false
        }
        else if let _ = json["data"]["identifier"].string {
            //App.Model.Task.updateSynced(self.task)
            return true
        }
        return false
    }
}
