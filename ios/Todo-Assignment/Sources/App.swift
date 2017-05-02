// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
    
    static let NgrokDomain = "8061e5be.ngrok.io"
    
    /// APIアクセサ
    static var API: ApiAccessor = ApiAccessor(baseURL: "https://\(NgrokDomain)/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}

