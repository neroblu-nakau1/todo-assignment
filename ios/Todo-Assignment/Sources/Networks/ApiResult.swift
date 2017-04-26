// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// APIリクエスト結果
class ApiResult {
    
    /// エラーオブジェクト(エラー時のみ代入される)
    var error: Error?
    
    /// HTTPステータスコード
    var statusCode: Int = 0
    
    /// リクエストされたURL
    var requestedURL = ""
    
    /// 成功/失敗
    var ok: Bool {
        return self.error == nil
    }
}
