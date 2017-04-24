// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailViewController: UIViewController {
    
    typealias DateChangedHandler = (Date) -> ()
    
    @IBOutlet fileprivate weak var tableView:       UITableView!
    @IBOutlet fileprivate weak var titleTextField:  UITextField!
    @IBOutlet fileprivate weak var tableViewBottom: NSLayoutConstraint!
    
    fileprivate var adapter: DetailTableViewController!
    fileprivate var keyboard: KeyboardEventManager!
    
    fileprivate var task: Task!
    
    fileprivate var hiddenTextField:     UITextField?
    fileprivate var dateChangedHandler: DateChangedHandler?
    
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
        let datePicker = self.createDatePickerView(mode: .date, initialDate: self.task.date) { [unowned self] date in
            print(date.dateString)
        }
        self.showInputView(datePicker)
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
    
    /// 入力用ビューを表示する
    /// - parameter mode: デートピッカーモード
    /// - parameter initialDate: 日付の初期値
    /// - parameter dateSelected: 値変更時のコールバック
    fileprivate func createDatePickerView(mode: UIDatePickerMode, initialDate: Date?, dateChanged: @escaping DateChangedHandler) -> UIDatePicker {
        self.dateChangedHandler = dateChanged
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.date           = initialDate ?? Date()
        datePicker.calendar       = Date.calendar
        datePicker.locale         = Locale.current
        datePicker.timeZone       = TimeZone.current
        datePicker.addTarget(self, action: #selector(didChangeValueDatePicker(datePicker:)), for: .valueChanged)
        
        return datePicker
    }
    
    @objc private func didChangeValueDatePicker(datePicker: UIDatePicker) {
        self.dateChangedHandler?(datePicker.date)
    }
}













