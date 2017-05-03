// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
	
	static let Domain = "2db6dae4.ngrok.io"
	
    /// APIアクセサ
    static var API: ApiAccessor = ApiAccessor(baseURL: "https://\(App.Domain)/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}
