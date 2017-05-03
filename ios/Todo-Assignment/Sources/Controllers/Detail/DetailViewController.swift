// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailViewController: UIViewController {
    
    typealias DateChangedHandler = (Date) -> ()
    
    static let ReloadNotification = NSNotification.Name(rawValue: "DetailViewController.ReloadNotification")
    
    @IBOutlet fileprivate weak var tableView:       UITableView!
    @IBOutlet fileprivate weak var titleTextField:  UITextField!
    @IBOutlet fileprivate weak var tableViewBottom: NSLayoutConstraint!
    
    fileprivate var adapter: DetailTableViewController!
    fileprivate var keyboard: KeyboardEventManager!
    
    fileprivate var task: Task!
    
    fileprivate var hiddenTextField: UITextField?
    fileprivate var datePicker:      DatePickerViewController?
    
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
        self.observeNotifications(true)
    }
    
    deinit {
        self.observeNotifications(false)
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
		if textField.text!.isEmpty {
			UIAlertController.showOKAlert(self, message: "")
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

extension DetailViewController: DetailTableViewControllerDelegate {
    
    func didTapDate(_ adapter: DetailTableViewController) {
        self.showDatePickerView(mode: .date, initialDate: self.task.date) { [unowned self] date in
            App.Model.Task.update(self.task) { task in
                task.date = date
            }
            self.adapter.reloadData()
        }
    }
    
    func didTapNotify(_ adapter: DetailTableViewController) {
        self.showDatePickerView(mode: .dateAndTime, initialDate: self.task.notify?.date) { [unowned self] rawDate in
			let date = rawDate.fixed(second: 0)
            NotificationManager.startObserveRegister(self, selector: #selector(self.didRegisterNotify(notification:)))
			App.Model.Task.updateNotify(self.task, to: date)
            self.adapter.reloadData()
        }
    }
    
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
	
	func didTapRemoveNotify(_ adapter: DetailTableViewController) {
		App.Model.Task.updateNotify(self.task, to: nil)
		self.adapter.reloadData()
	}
	
    func didTapMemo(_ adapter: DetailTableViewController) {
        self.present(MemoEditViewController.create(title: self.task.title, initialText: self.task.memo) { [unowned self] text in
            App.Model.Task.update(self.task) { task in
                task.memo = text
            }
            self.adapter.reloadData()
        })
    }
	
    func didSelectPriority(_ adapter: DetailTableViewController, selectPriority priority: Int) {
        App.Model.Task.update(self.task) { task in
            task.priority = priority
        }
        self.adapter.reloadData()
    }
    
    func didTapDelete(_ adapter: DetailTableViewController) {
		UIAlertController.showDeleteConfirmActionSheet(self) { [unowned self] in
			App.Model.Task.delete(self.task)
			let _ = self.pop()
		}
    }
}

// MARK: - 日付時刻関連 -
extension DetailViewController {
    
    /// 入力用ビューを表示する
    /// - parameter view: 入力用のビュー
    fileprivate func showInputView(_ view: UIView) {
        if self.hiddenTextField != nil {
            return
        }
        
        let textField = UITextField();
        textField.isHidden = true
        self.view.addSubview(textField)
        
        textField.inputView = view
        textField.becomeFirstResponder()
        
        self.hiddenTextField = textField
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
}

// MARK: - 通知監視 -
extension DetailViewController {
    
    fileprivate func observeNotifications(_ start: Bool) {
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
    
    @objc private func didReceiveReloadNotification() {
        self.adapter.reloadData()
    }
}
