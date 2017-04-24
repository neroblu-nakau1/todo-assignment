// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet fileprivate weak var tableView:       UITableView!
    @IBOutlet fileprivate weak var titleTextField:  UITextField!
    @IBOutlet fileprivate weak var tableViewBottom: NSLayoutConstraint!
    
    fileprivate var adapter: DetailTableViewController!
    fileprivate var keyboard: KeyboardEventManager!
    
    fileprivate var task: Task!
    
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create(task: Task) -> DetailViewController {
        let ret = App.Storyboard("Detail").get(DetailViewController.self)
        ret.task = task
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupTitleTextField()
    }
    
    private func setupTableView() {
        self.adapter = DetailTableViewController()
        self.adapter.setup(self.tableView, task: self.task)
        self.adapter.delegate = self
    }
    
    private func setupTitleTextField() {
        self.keyboard = KeyboardEventManager() { [unowned self] distance in
            self.tableViewBottom.constant = distance
        }
        self.titleTextField.delegate = self
        self.titleTextField.text = self.task.title
    }
    
    @IBAction private func didTapBackButton() {
        let _ = self.pop()
    }
}

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailViewController: DetailTableViewControllerDelegate {
    
    func didTapDate(_ adapter: DetailTableViewController) {
        
    }
    
    func didTapNotify(_ adapter: DetailTableViewController) {
        
    }
    
    func didTapMemo(_ adapter: DetailTableViewController) {
        self.present(MemoEditViewController.create(initialText: self.task.memo) { [unowned self] text in
            App.Model.Task.update(self.task) { task, i in
                task.memo = text
            }
            self.adapter.reloadData()
        })
    }
    
    func didTapRemoveNotify(_ adapter: DetailTableViewController) {
        
    }
    
    func didSelectPriority(_ adapter: DetailTableViewController) {
        
    }
    
    func didTapDelete(_ adapter: DetailTableViewController) {
        
    }
}
