// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
    
    static let NgrokDomain = "2db6dae4.ngrok.io"
    
    /// APIアクセサ
    static var API: ApiAccessor = ApiAccessor(baseURL: "https://\(NgrokDomain)/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}

