// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

extension UIButton {
    
    /// ボタンタイトル(通常時)
    var title: String {
        get    { return self.title(for: .normal) ?? "" }
        set(v) { self.setTitle(v, for: .normal) }
    }
    
    /// ボタン画像(通常時)
    var image: UIImage? {
        get    { return self.image(for: .normal) }
        set(v) { self.setImage(v, for: .normal) }
    }
}
