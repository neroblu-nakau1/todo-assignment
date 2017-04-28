// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
    
    private static let Ngrok = "414af44d"
    
    /// APIアクセサ
    static let API: ApiAccessor = ApiAccessor(baseURL: "https://\(Ngrok).ngrok.io/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}

