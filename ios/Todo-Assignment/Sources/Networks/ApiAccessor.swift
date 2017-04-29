// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import Alamofire
import SwiftyJSON

/// APIリクエストプロトコル
class ApiAccessor {
    
    /// ベースURL
    let baseURL: String
    
    /// イニシャライザ
    /// - parameter baseURL: ベースURL
    init(baseURL: String) {
        self.baseURL = baseURL
    }

    /// APIにリクエストを送る
    /// - parameter requestable: ApiRequestableを実装したリクエストオブジェクト
    /// - parameter handler: APIよりレスポンスが帰ってきた時のイベントハンドラ
    func request<T: ApiRequestable>(_ requestable: T, handler: @escaping (T.Response?, ApiResult) -> ()) {
        let urlString = "\(self.baseURL)\(requestable.endpoint)"
        
        let config = URLSessionConfiguration.default
        if let timeoutInterval = requestable.requestTimeoutInterval {
            config.timeoutIntervalForRequest = timeoutInterval
        }
        
        let request = Alamofire.request(
            urlString,
            method:     requestable.method,
            parameters: requestable.parameters,
            encoding:   URLEncoding.default,
            headers:    requestable.headers
        )
        
        request.responseJSON() { data in
            let result = ApiResult()
            result.statusCode   = data.response?.statusCode         ?? 0
            result.requestedURL = data.request?.url?.absoluteString ?? ""
            
            if let err = data.result.error {
                result.error = err
                handler(nil, result)
            }
            guard let value = data.result.value else {
                handler(nil, result)
                return
            }
            let json = JSON(value)
            requestable.parseToken(json)
            handler(requestable.parse(json), result)
        }
        print(request.curlDescription)
    }
}

// MARK: - Alamofire.DataRequest拡張 -
extension Alamofire.DataRequest {
    
    /// デバッグ用のcurlコマンド文字列
    var curlDescription: String {
        var ret = self.debugDescription
        for char in ["$ ", "\t"] {
            ret = ret.replacingOccurrences(of: char, with: "")
        }
        return ret
    }
}
