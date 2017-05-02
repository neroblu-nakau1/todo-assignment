// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
    
    private static let NgrokDomain = "8061e5be.ngrok.io"
    
    /// APIアクセサ
    static let API: ApiAccessor = ApiAccessor(baseURL: "https://\(NgrokDomain)/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}

