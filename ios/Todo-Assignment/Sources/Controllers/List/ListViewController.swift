// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class ListViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet fileprivate weak var titleLabel:           UILabel!
    @IBOutlet fileprivate weak var tableView:            UITableView!
    @IBOutlet fileprivate weak var bottomBar:            UIView!
    @IBOutlet fileprivate weak var addButton:            UIButton!
    @IBOutlet fileprivate weak var addTextField:         UITextField!
    @IBOutlet fileprivate weak var taskSegmentedControl: UISegmentedControl!
    @IBOutlet fileprivate weak var tableViewBottom:      NSLayoutConstraint!
    @IBOutlet fileprivate weak var editButton:           UIButton!
    @IBOutlet fileprivate weak var trashButton:          UIButton!
    @IBOutlet fileprivate weak var allSelectButton:      UIButton!
    @IBOutlet fileprivate weak var notifyButton:         UIButton!
    
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
        self.isEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adapter.reloadData()
    }
    
    private func setupTableView() {
        App.Model.Task.loadAll()
        self.adapter = ListTableViewController()
        self.adapter.setup(
            tableView,
            selected: { [unowned self] task in
                self.push(DetailViewController.create(task: task))
            },
            tappedCompleted: { [unowned self] task in
                App.Model.Task.updateCompleted(task)
                self.adapter.reloadData()
            }
        )
    }
    
    private func setupAddTextField() {
        self.keyboard = KeyboardEventManager() { [unowned self] distance in
            self.tableViewBottom.constant = distance
        }
        self.addTextField.delegate = self
    }
    
    /// タイトルラベルの更新
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
    
    /// 編集ボタン押下時
    @IBAction private func didTapEditButton() {
        self.isEditing = !self.isEditing
    }
    
    /// ゴミ箱ボタン押下時
    @IBAction private func didTapTrashButton() {
        
    }
    
    /// 全選択ボタン押下時
    @IBAction private func didTapAllSelectButton() {
        self.adapter.toggleAllSelected()
    }
    
    /// 通知ボタン押下時
    @IBAction private func didTapNotifyButton() {
        
    }

    /// テキストフィールドリターンキー押下時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let title = self.addTextField.text, !title.isEmpty {
            let newTask = App.Model.Task.create(title: title)
            App.Model.Task.save(newTask)
            self.adapter.reloadData()
        }
        self.addTextField.text = ""
        self.addTextField.resignFirstResponder()
        return true
    }
    
    override var isEditing: Bool {
        didSet { let v = self.isEditing
            self.editButton.title = v ? "完了" : "編集"
            
            self.notifyButton.isHidden    =  v
            self.trashButton.isHidden     = !v
            self.allSelectButton.isHidden = !v
            
            self.adapter.isEditing = v
        }
    }
}
