// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
    
    /// APIアクセサ
    static let API: ApiAccessor = ApiAccessor(baseURL: "https://jsonip.com/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}

