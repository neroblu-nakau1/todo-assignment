// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// UIViewControllerのナビゲーション処理をラップするプロトコル
protocol Navigatable {}

extension UIViewController: Navigatable {
    
    /// ナビゲーションスタックにビューコントローラをプッシュして表示を更新する
    /// - parameter viewController: ビューコントローラ
    /// - parameter animated: アニメーションの有無
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /// ナビゲーションスタックからトップビューコントローラをポップして表示を更新する
    /// - parameter animated: アニメーションの有無
    /// - returns: ポップしたトップビューコントローラ
    func pop(animated: Bool = true) -> UIViewController? {
        return self.navigationController?.popViewController(animated: animated)
    }
    
    /// ルートビューコントローラを除いて、スタック上のすべてのビューコントローラをポップして表示を更新する
    /// - parameter animated: アニメーションの有無
    /// - returns: ポップされたビューコントローラの配列
    func popToRoot(animated: Bool = true) -> [UIViewController]? {
        return self.navigationController?.popToRootViewController(animated: animated)
    }
    
    /// 指定されたビューコントローラがナビゲーションスタックの最上位に位置するまでポップして表示を更新する
    /// - parameter viewController: ビューコントローラ
    /// - parameter animated: アニメーションの有無
    /// - returns: ポップされたビューコントローラの配列
    func popTo(_ viewController: UIViewController, animated: Bool = true) -> [UIViewController]? {
        return self.navigationController?.popToViewController(viewController, animated: animated)
    }
}
