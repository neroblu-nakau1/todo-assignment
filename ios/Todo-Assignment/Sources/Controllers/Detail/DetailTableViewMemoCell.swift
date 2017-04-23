// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailTableViewMemoCell: DetailTableViewCell {
    
    @IBOutlet fileprivate weak var memoLabel: UILabel!
    @IBOutlet fileprivate weak var placeholderLabel: UILabel!
    
    override var task: Task! {
        didSet {
            self.memoLabel.text = self.task.memo
            self.placeholderLabel.isHidden = !self.task.memo.isEmpty
        }
    }
}
