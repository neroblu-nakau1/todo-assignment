// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// アプリケーション
class App {
	
	static let Domain = "4da83275.ngrok.io"
	
    /// APIアクセサ
    static var API: ApiAccessor = ApiAccessor(baseURL: "https://\(App.Domain)/api/")
    
    /// モデル(各モデルで拡張)
    class Model {}
}
