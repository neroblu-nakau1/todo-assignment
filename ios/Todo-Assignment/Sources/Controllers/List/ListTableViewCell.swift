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
    
    var task: Task! {
        didSet { let v = self.task
            titleLabel.text = v?.title
            //dateLabel.text = v.date
        }
    }
    
    @IBAction private func didTapCompleteButton() {
        self.tappedCompleted?(self.task)
    }
}
