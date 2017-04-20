// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView:    UITableView!
    @IBOutlet fileprivate weak var bottomBar:    UIView!
    @IBOutlet fileprivate weak var addButton:    UIButton!
    @IBOutlet fileprivate weak var addTextField: UITextField!
    
    private var adapter: ListTableViewController!
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create() -> UINavigationController {
        let ret = App.Storyboard("List").get(UINavigationController.self)
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.adapter = ListTableViewController()
        self.adapter.setup(self.tableView)
    }
}

extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
