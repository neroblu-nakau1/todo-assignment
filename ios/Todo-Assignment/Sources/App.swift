// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
    
    private static let NgrokDomain = "84dffafd.ngrok.io"
    
    /// APIアクセサ
    static let API: ApiAccessor = ApiAccessor(baseURL: "https://\(NgrokDomain)/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}

