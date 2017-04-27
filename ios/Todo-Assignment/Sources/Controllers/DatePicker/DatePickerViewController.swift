// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 日付ピッカービューコントローラ
class DatePickerViewController: UIViewController {
    
    typealias DateChangedHandler = (Date) -> ()
    typealias CompletedHandler   = (Date) -> ()
    
    @IBOutlet private(set) weak var datePicker: UIDatePicker!
    @IBOutlet private(set) weak var zeroButton: UIButton!
    
    /// 値変更時コールバック
    var dateChanged: DateChangedHandler?
    
    /// 完了押下時コールバック
    var completed: CompletedHandler?
    
    private var mode = UIDatePickerMode.date
    
    private var initialDate = Date()
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create(mode: UIDatePickerMode, initialDate: Date?) -> DatePickerViewController {
        let ret = App.Storyboard("DatePicker").get(DatePickerViewController.self)
        ret.mode = mode
        ret.initialDate = initialDate ?? Date()
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.datePickerMode = self.mode
        self.datePicker.date           = self.initialDate
        self.datePicker.calendar       = Date.calendar
        self.datePicker.locale         = Locale.current
        self.datePicker.timeZone       = TimeZone.current
        
        self.zeroButton.isHidden = datePicker.datePickerMode == .date
        self.dateChanged?(self.datePicker.date)
    }
    
    /// 日付ピッカー値変更時
    @IBAction func didChangeDatePicker() {
        self.dateChanged?(self.datePicker.date)
    }
    
    /// 完了ボタン押下時
    @IBAction func didTapCompleteButton() {
        self.completed?(self.datePicker.date)
    }
    
    /// ":00"ボタン押下時
    @IBAction func didTapZeroButton() {
        self.datePicker.setDate(self.datePicker.date.fixed(minute: 0), animated: true)
        self.dateChanged?(self.datePicker.date)
    }
}
