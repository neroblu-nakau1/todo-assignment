// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// APIリクエスト結果
class ApiResult {
    
    var error: Error?
    
    var statusCode: Int = 0
    
    var requestedURL = ""
    
    /// 成功/失敗
    var ok: Bool {
        return self.error == nil
    }
}

extension ApiResult: CustomStringConvertible {
    
    var description: String {
        return ""
    }
}
