// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 詳細画面ビューコントローラ
class DetailViewController: UIViewController {
    
    /// リロード要求通知
    static let ReloadNotification = NSNotification.Name(rawValue: "DetailViewController.ReloadNotification")
    
    typealias DateChangedHandler = (Date) -> ()
    
    @IBOutlet private weak var tableView:       UITableView!
    @IBOutlet private weak var titleTextField:  UITextField!
    @IBOutlet private weak var tableViewBottom: NSLayoutConstraint!
    
    fileprivate var task: Task!
    fileprivate var adapter: DetailTableViewAdapter!
    private var keyboard: KeyboardEventManager!
    
    private var hiddenTextField: UITextField?
    private var datePicker: DatePickerViewController?
    
    /// インスタンスを生成する
    /// - parameter task: タスクエンティティ
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
        self.observeNotifications(true)
    }
    
    deinit {
        self.observeNotifications(false)
    }
    
    /// テーブルビューの初期セットアップ
    private func setupTableView() {
        self.adapter = DetailTableViewAdapter()
        self.adapter.setup(self.tableView, task: self.task)
        self.adapter.delegate = self
    }
    
    /// タイトル名テキストフィールドの初期セットアップ
    private func setupTitleTextField() {
        self.keyboard = KeyboardEventManager() { [unowned self] distance in
            self.tableViewBottom.constant = distance
        }
        self.titleTextField.delegate = self
        self.titleTextField.text = self.task.title
    }
    
    /// 戻るボタン押下時
    @IBAction private func didTapBackButton() {
        let _ = self.pop()
    }
    
    /// キーボードが表示されていれば下ろす
    fileprivate func resignKeyboardIfNeed() {
        if self.titleTextField.isFirstResponder {
            self.titleTextField.resignFirstResponder()
        }
        if self.hiddenTextField?.isFirstResponder ?? false {
            self.hideInputView()
        }
    }
    
    /// 入力用ビューを表示する
    /// - parameter view: 入力用のビュー
    fileprivate func showInputView(_ view: UIView) {
        let textField: UITextField
        if self.hiddenTextField != nil {
            textField = self.hiddenTextField!
        } else {
            textField = UITextField()
            textField.isHidden = true
            self.view.addSubview(textField)
            self.hiddenTextField = textField
        }
        
        textField.inputView = view
        textField.reloadInputViews()
        textField.becomeFirstResponder()
    }
    
    /// 入力用ビューを非表示にする
    fileprivate func hideInputView() {
        guard let textField = self.hiddenTextField else {
            return
        }
        textField.removeFromSuperview()
        self.hiddenTextField = nil
    }
    
    /// 日付ピッカーを表示する
    /// - parameter mode: デートピッカーモード
    /// - parameter initialDate: 日付の初期値
    /// - parameter dateSelected: 値変更時のコールバック
    fileprivate func showDatePickerView(mode: UIDatePickerMode, initialDate: Date?, dateChanged: @escaping DatePickerViewController.DateChangedHandler) {
        
        let vc = DatePickerViewController.create(mode: mode, initialDate: initialDate)
        vc.dateChanged = dateChanged
        vc.completed = { [unowned self] date in
            self.hideInputView()
            self.datePicker = nil
        }
        self.datePicker = vc
        self.showInputView(vc.view)
    }
    
    /// 通知の監視開始/監視終了
    /// - parameter start: 開始/終了
    private func observeNotifications(_ start: Bool) {
        let items: [NSNotification.Name : Selector] = [
            DetailViewController.ReloadNotification : #selector(didReceiveReloadNotification),
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

// MARK: - UITextFieldDelegate -

extension DetailViewController: UITextFieldDelegate {
    
    /// リターンキー押下時
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.text!.isEmpty {
			UIAlertController.showOKAlert(self, message: "ToDoの名前を空にすることはできません")
			textField.text = self.task.title
		} else {
			App.Model.Task.update(self.task) { task in
				task.title = textField.text!
			}
		}
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - DetailTableViewAdapterDelegate -

extension DetailViewController: DetailTableViewAdapterDelegate {
    
    /// 日付が押下された時
    func didTapDate(_ adapter: DetailTableViewAdapter) {
        self.showDatePickerView(mode: .date, initialDate: self.task.date) { [unowned self] date in
            App.Model.Task.update(self.task) { task in
                task.date = date
            }
            self.adapter.reloadData()
        }
    }
    
    /// 通知が押下された時
    func didTapNotify(_ adapter: DetailTableViewAdapter) {
        self.showDatePickerView(mode: .dateAndTime, initialDate: self.task.notify?.date) { [unowned self] rawDate in
			let date = rawDate.fixed(second: 0)
            NotificationManager.startObserveRegister(self, selector: #selector(self.didRegisterNotify(notification:)))
			App.Model.Task.updateNotify(self.task, to: date)
            self.adapter.reloadData()
        }
    }
    
    /// ローカル通知が登録された時
    /// - parameter notification: 通知内容
    func didRegisterNotify(notification: Notification) {
        if let result = notification.userInfo?[NotificationManager.RegistrationResultKey] as? NotificationManager.RegistrationResult {
            if !result.ok {
                onMainThread {
                    UIAlertController.showOKAlert(self, message: result.message)
                    App.Model.Task.updateNotify(self.task, to: nil)
                    self.adapter.reloadData()
                    self.hideInputView()
                }
            }
        }
        NotificationManager.stopObserveRegister(self)
    }
	
    /// 通知削除が押下された時
	func didTapRemoveNotify(_ adapter: DetailTableViewAdapter) {
        self.resignKeyboardIfNeed()
		App.Model.Task.updateNotify(self.task, to: nil)
		self.adapter.reloadData()
	}
	
    /// メモが押下された時
    func didTapMemo(_ adapter: DetailTableViewAdapter) {
        self.resignKeyboardIfNeed()
        self.present(MemoEditViewController.create(title: self.task.title, initialText: self.task.memo) { [unowned self] text in
            App.Model.Task.update(self.task) { task in
                task.memo = text
            }
            self.adapter.reloadData()
        })
    }
	
    /// 重要度の値が選択された時
    func didSelectPriority(_ adapter: DetailTableViewAdapter, selectPriority priority: Int) {
        self.resignKeyboardIfNeed()
        App.Model.Task.update(self.task) { task in
            task.priority = priority
        }
        self.adapter.reloadData()
    }
    
    /// 削除が押下された時
    func didTapDelete(_ adapter: DetailTableViewAdapter) {
        self.resignKeyboardIfNeed()
		UIAlertController.showDeleteConfirmActionSheet(self) { [unowned self] in
			App.Model.Task.delete(self.task)
			let _ = self.pop()
		}
    }
}
