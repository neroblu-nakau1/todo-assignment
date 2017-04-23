// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailTableViewPriorityCell: DetailTableViewCell {
    
    //@IBOutlet fileprivate weak var memoLabel: UILabel!
    
    override var task: Task! {
        didSet {
            //self.memoLabel.text = self.task.memo
        }
    }
}
