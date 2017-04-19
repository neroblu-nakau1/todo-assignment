// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// UIViewControllerのモーダル表示処理をラップするプロトコル
public protocol Presentable {}

extension UIViewController: Presentable {
    
    /// モーダルでビューコントローラを表示する
    /// - parameter viewController: ビューコントローラ
    /// - parameter transitionStyle: 表示エフェクトスタイル
    /// - parameter completion: 表示完了時の処理
    func present(_ viewController: UIViewController, transitionStyle: UIModalTransitionStyle? = nil, completion: (() -> Swift.Void)? = nil) {
        if let transition = transitionStyle {
            viewController.modalTransitionStyle = transition
        }
        self.present(viewController, animated: true, completion: completion)
    }
    
    /// モーダルで表示されたビューコントローラを閉じる
    /// - parameter completion: 閉じ終えた時の処理
    func dismiss(_ completion: (() -> Swift.Void)? = nil) {
        self.dismiss(animated: true, completion: completion)
    }
}
