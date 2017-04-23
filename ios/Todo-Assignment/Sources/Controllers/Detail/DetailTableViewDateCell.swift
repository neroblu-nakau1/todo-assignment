// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailTableViewDateCell: DetailTableViewCell {
    
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    
    override var task: Task! {
        didSet {
            self.dateLabel.text = self.task.date.dateString
        }
    }
}
