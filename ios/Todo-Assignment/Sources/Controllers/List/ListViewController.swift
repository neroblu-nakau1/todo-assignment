// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class ListViewController: UIViewController, UITextFieldDelegate {
    
    /// リロード要求通知
    static let ReloadNotification = NSNotification.Name(rawValue: "ListViewController.ReloadNotification")
    
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
    
    /// テーブルビューアダプタ
    fileprivate var adapter: ListTableViewAdapter!
    
    /// キーボードイベント管理
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
        self.observeNotifications(true)
        self.isEditing = false
		
		self.bottomBar.setGradient(color1: UIColor.red, color2: UIColor.blue)
    }
    
    deinit {
        self.observeNotifications(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adapter.reloadData()
    }
    
    /// テーブルビューの初期セットアップ
    private func setupTableView() {
        App.Model.Task.loadAll()
        self.adapter = ListTableViewAdapter()
        self.adapter.setup(
            tableView,
            selected: { [unowned self] task in
                self.push(DetailViewController.create(task: task))
            },
            tappedCompleted: { [unowned self] task in
                App.Model.Task.update(task) { task in
                    task.isCompleted = !task.isCompleted
                }
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
        UIAlertController.showDeleteConfirmActionSheet(self) { [unowned self] in
            App.Model.Task.delete(ids: self.adapter.selectedIds)
            self.adapter.clearSelectedItems()
        }
    }
    
    /// 全選択ボタン押下時
    @IBAction private func didTapAllSelectButton() {
        self.adapter.toggleAllSelected()
    }
    
    /// 通知ボタン押下時
    @IBAction private func didTapNotifyButton() {
		Hud.show("サーバーと同期しています")
        App.Model.ServerSync.synchronize {
            Hud.hide("完了しました")
        }
    }
    
    /// 戻るボタン押下時
    @IBAction private func didTapBackButton() {
        self.dismiss()
    }

    /// テキストフィールドリターンキー押下時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let title = self.addTextField.text, !title.isEmpty {
            let newTask = App.Model.Task.create(title: title)
            App.Model.Task.add(newTask)
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

// MARK: - 通知監視 -
extension ListViewController {
    
    fileprivate func observeNotifications(_ start: Bool) {
        let items: [NSNotification.Name : Selector] = [
            ListViewController.ReloadNotification : #selector(didReceiveReloadNotification),
            ]
        for (name, selector) in items {
            if start {
                NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self, name: name, object: nil)
            }
        }
    }
    
    @objc private func didReceiveReloadNotification() {
        self.adapter.reloadData()
    }
}
