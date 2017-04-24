// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class ListTableViewCell: UITableViewCell {
    
    typealias TappedCompletedClosure = (Task) -> ()
    
    var tappedCompleted: TappedCompletedClosure?
    
    @IBOutlet fileprivate weak var titleLabel:      UILabel!
    @IBOutlet fileprivate weak var dateLabel:       UILabel?
    @IBOutlet fileprivate weak var priorityImage:   UIImageView?
    @IBOutlet fileprivate weak var completeButton:  UIButton?
    @IBOutlet fileprivate weak var checkBox:        UIButton?
    
    var task: Task! {
        didSet { let v = self.task
            titleLabel.text = v?.title
            dateLabel?.text = v?.date.dateString
        }
    }
    
    var isChecked: Bool = false {
        didSet { let v = self.isChecked
            if let checkbox = self.checkBox {
                checkbox.isSelected = v
            }
        }
    }
    
    @IBAction private func didTapCompleteButton() {
        self.tappedCompleted?(self.task)
    }
}
