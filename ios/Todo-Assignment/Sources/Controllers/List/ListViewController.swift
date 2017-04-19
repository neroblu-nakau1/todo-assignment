// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class ListViewController: UIViewController {
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create() -> ListViewController {
        let ret = App.Storyboard("List").get(ListViewController.self)
        return ret
    }
}
