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
    
    /// 日付ピッカー値変更時
    @IBAction func didChangeDatePicker() {
        self.dateChanged?(self.datePicker.date)
    }
    
    /// 完了ボタン押下時
    @IBAction func didTapCompleteButton() {
        self.completed?(self.datePicker.date)
    }
}
