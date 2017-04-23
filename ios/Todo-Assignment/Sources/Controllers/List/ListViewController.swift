// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet fileprivate weak var titleLabel:           UILabel!
    @IBOutlet fileprivate weak var tableView:            UITableView!
    @IBOutlet fileprivate weak var bottomBar:            UIView!
    @IBOutlet fileprivate weak var addButton:            UIButton!
    @IBOutlet fileprivate weak var addTextField:         UITextField!
    @IBOutlet fileprivate weak var taskSegmentedControl: UISegmentedControl!
    @IBOutlet fileprivate weak var tableViewBottom:      NSLayoutConstraint!
    
    private var adapter: ListTableViewController!
    private var keyboard: KeyboardEventManager!
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create() -> UINavigationController {
        let ret = App.Storyboard("List").get(UINavigationController.self)
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupAddTextField()
        self.updateTitleLabel()
    }
    
    private func setupTableView() {
        App.Model.Task.loadAll()
        self.adapter = ListTableViewController()
        self.adapter.setup(
            tableView,
            selected: { [unowned self] task in
                self.push(DetailViewController.create())
            },
            tappedCompleted: { [unowned self] task in
                print(1)
            }
        )
    }
    
    private func setupAddTextField() {
        self.keyboard = KeyboardEventManager() { [unowned self] distance in
            self.tableViewBottom.constant = distance
        }
        self.addTextField.delegate = self
    }
    
    private func updateTitleLabel() {
        self.titleLabel.text = self.taskSegmentedControl.titleForSegment(at: self.taskSegmentedControl.selectedSegmentIndex) ?? ""
    }
    
    /// 追加ボタン押下時
    @IBAction private func didTapAddButton() {
        if !self.addTextField.isFirstResponder {
            self.addTextField.becomeFirstResponder()
        }
    }
    
    /// セグメントコントロール切替時
    @IBAction private func didChangeTaskSegmentedControl() {
        let taskSegment = TaskSegment(rawValue: self.taskSegmentedControl.selectedSegmentIndex)!
        self.adapter.taskSegment = taskSegment
        self.updateTitleLabel()
    }
}

extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
