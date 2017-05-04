// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 一覧画面用テーブルセル
class ListTableViewCell: UITableViewCell {
    
    typealias TappedCompletedClosure = (Task) -> ()
    
    /// 完了ボタン押下時のコールバック
    var tappedCompleted: TappedCompletedClosure?
    
    @IBOutlet private weak var titleLabel:     UILabel!
    @IBOutlet private weak var dateLabel:      UILabel?
    @IBOutlet private weak var priorityImage:  UIImageView?
    @IBOutlet private weak var completeButton: UIButton?
    @IBOutlet private weak var checkBox:       UIButton?
    
    /// タスク
    var task: Task! {
        didSet { let v = self.task!
            self.titleLabel.text = v.title
            self.dateLabel?.text = v.date.dateString
            self.priorityImage?.image = UIImage(named: "rate\(v.priority)")
        }
    }
    
    /// チェックボックスのON/OFF(編集モード用)
    var isChecked: Bool = false {
        didSet { let v = self.isChecked
            if let checkbox = self.checkBox {
                checkbox.isSelected = v
            }
        }
    }
    
    /// 完了ボタン押下時
    @IBAction private func didTapCompleteButton() {
        self.tappedCompleted?(self.task)
    }
}
