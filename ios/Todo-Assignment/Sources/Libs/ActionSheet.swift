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


extension UIAlertController {
	
	class func showDeleteConfirmActionSheet(_ controller: UIViewController, confirmed: @escaping ()->()) {
		self.showActionSheet(controller, title: "削除しますか?", message: nil, actions: [
			UIAlertAction(destructive: "削除します", confirmed),
			UIAlertAction(cancel: "キャンセル"),
			])
	}
	
	class func showOKAlert(_ controller: UIViewController, message: String) {
		self.showActionSheet(controller, title: nil, message: message, actions: [
			UIAlertAction(destructive: "OK"),
			])
	}
}

/// UIAlertController拡張
extension UIAlertController {
	
	/// アラートを表示する
	/// - parameter controller: 表示を行うビューコントローラ
	/// - parameter title: タイトル文言
	/// - parameter message: メッセージ文言
	/// - parameter actions: UIAlertActionの配列
	/// - parameter style: UIAlertControllerStyle
	private class func show(_ controller: UIViewController, title: String?, message: String?, actions: [UIAlertAction], style: UIAlertControllerStyle) {
		if actions.isEmpty { return }
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: style)
		actions.forEach { alert.addAction($0) }
		controller.present(alert, animated: true, completion: nil)
	}
	
    fileprivate class func showActionSheet(_ controller: UIViewController, title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
		self.show(controller, title: title, message: message, actions: actions, style: .actionSheet)
    }
	
	fileprivate class func showAlert(_ controller: UIViewController, title: String? = nil, message: String? = nil, actions: [UIAlertAction]) {
		self.show(controller, title: title, message: message, actions: actions, style: .alert)
	}
}

