// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 日付ピッカービューコントローラ
class DatePickerViewController: UIViewController {
    
    typealias DateChangedHandler = (Date) -> ()
    typealias CompletedHandler = (Date) -> ()
    
    @IBOutlet fileprivate(set) weak var datePicker: UIDatePicker!
    
    /// 値変更時コールバック
    var dateChanged: DateChangedHandler?
    
    /// 完了押下時コールバック
    var completed: CompletedHandler?
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create() -> DatePickerViewController {
        let ret = App.Storyboard("DatePicker").get(DatePickerViewController.self)
        return ret
    }
    
    @IBAction func didChangeDatePicker() {
        self.dateChanged?(self.datePicker.date)
    }
    
    @IBAction func didTapCompleteButton() {
        self.completed?(self.datePicker.date)
    }
}
