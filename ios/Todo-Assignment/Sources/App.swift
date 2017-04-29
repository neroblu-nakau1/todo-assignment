// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
    
    private static let NgrokDomain = "cab6fa4e.ngrok.io"
    
    /// APIアクセサ
    static let API: ApiAccessor = ApiAccessor(baseURL: "https://\(NgrokDomain)/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}

