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

/// オプショナルの値も渡せるprint関数
/// - parameter items: 値(可変長引数)
/// - parameter separator: セパレータ文字
/// - parameter terminator: 終了文字
public func print(_ items: Any?..., separator: String = ", ", terminator: String = "\n") {
    for (i, item) in items.enumerated() {
        let t = (i == items.indices.last!) ? terminator : separator
        print(item ?? NSNull(), terminator: t)
    }
}
