// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// UIAlertActionのコンビニエンスコンストラクタ群
extension UIAlertAction {
    
    /// イニシャライザ (UIAlertActionStyle.defaultとして初期化)
    /// - parameter title: タイトル
    /// - parameter handler: 押下時のハンドラ
    convenience init(default title: String?, _ handler: (() -> ())? = nil) {
        self.init(title: title, style: .default, handler: { _ in handler?() })
    }
    
    /// イニシャライザ (UIAlertActionStyle.destructiveとして初期化)
    /// - parameter title: タイトル
    /// - parameter handler: 押下時のハンドラ
    convenience init(destructive title: String?, _ handler: (() -> ())? = nil) {
        self.init(title: title, style: .destructive, handler: { _ in  handler?() })
    }
    
    /// イニシャライザ (UIAlertActionStyle.cancelとして初期化)
    /// - parameter title: タイトル
    /// - parameter handler: 押下時のハンドラ
    convenience init(cancel title: String?, _ handler: (() -> ())? = nil) {
        self.init(title: title, style: .cancel, handler: { _ in handler?() })
    }
}

/// アクションシート用の拡張
extension UIAlertController {
    
    class func showActionSheet(_ controller: UIViewController, title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
        if actions.isEmpty { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { alert.addAction($0) }
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func showDeleteConfirmActionSheet(_ controller: UIViewController, confirmed: @escaping ()->()) {
        self.showActionSheet(controller, title: "削除しますか?", message: nil, actions: [
            UIAlertAction(destructive: "削除します", confirmed),
            UIAlertAction(cancel: "キャンセル"),
            ])
    }
}
