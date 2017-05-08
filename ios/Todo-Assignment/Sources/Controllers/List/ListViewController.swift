// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 一覧画面ビューコントローラ
class ListViewController: UIViewController, UITextFieldDelegate {
    
    /// リロード要求通知
    static let ReloadNotification = NSNotification.Name(rawValue: "ListViewController.ReloadNotification")
    
    @IBOutlet private weak var titleLabel:           UILabel!
    @IBOutlet private weak var tableView:            UITableView!
    @IBOutlet private weak var bottomBar:            UIView!
    @IBOutlet private weak var addButton:            UIButton!
    @IBOutlet private weak var addTextField:         UITextField!
    @IBOutlet private weak var taskSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableViewBottom:      NSLayoutConstraint!
    @IBOutlet private weak var editButton:           UIButton!
    @IBOutlet private weak var trashButton:          UIButton!
    @IBOutlet private weak var allSelectButton:      UIButton!
    @IBOutlet private weak var syncButton:           UIButton!
    @IBOutlet private weak var backButton:           UIButton!
    
    /// テーブルビューアダプタ
    private var adapter: ListTableViewAdapter!
    
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
        self.setupBackButton()
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
    
    /// タスク追加テキストフィールドの初期セットアップ
    private func setupAddTextField() {
        self.keyboard = KeyboardEventManager() { [unowned self] distance in
            self.tableViewBottom.constant = distance
        }
        self.addTextField.delegate = self
    }
    
    /// 戻るボタンの初期セットアップ(主にデバッグ用)
    private func setupBackButton() {
        self.backButton.isHidden = (self.presentingViewController == nil)
    }
    
    /// ヘッダタイトルラベルの更新
    private func updateTitleLabel() {
        self.titleLabel.text = self.taskSegmentedControl.titleForSegment(at: self.taskSegmentedControl.selectedSegmentIndex) ?? ""
    }
    
    /// 追加ボタン押下時
    @IBAction private func didTapAddButton() {
        if !self.addTextField.isFirstResponder {
            self.addTextField.becomeFirstResponder()
        }
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
    
    /// 同期ボタン押下時
    @IBAction private func didTapSyncButton() {
        UIAlertController.showSyncConfirmActionSheet(self) {
            Hud.show("サーバーと同期しています")
            App.Model.ServerSync.synchronize {
                Hud.hide("完了しました")
            }
        }
    }
    
    /// 戻るボタン押下時
    @IBAction private func didTapBackButton() {
        self.dismiss()
    }
    
    /// セグメントコントロール切替時
    @IBAction private func didChangeTaskSegmentedControl() {
        let taskSegment = TaskSegment(rawValue: self.taskSegmentedControl.selectedSegmentIndex)!
        self.adapter.taskSegment = taskSegment
        self.updateTitleLabel()
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
    
    /// 編集モード
    override var isEditing: Bool {
        didSet { let v = self.isEditing
            self.editButton.title = v ? "完了" : "編集"
            
            self.syncButton.isHidden    =  v
            self.trashButton.isHidden     = !v
            self.allSelectButton.isHidden = !v
            
            self.adapter.isEditing = v
        }
    }
    
    /// 通知の監視開始/監視終了
    /// - parameter start: 開始/終了
    private func observeNotifications(_ start: Bool) {
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
    
    /// リロードの通知が来た時
    @objc private func didReceiveReloadNotification() {
        self.adapter.reloadData()
    }
}
