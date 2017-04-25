// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailTableViewNotifyCell: DetailTableViewCell {
    
    typealias TappedRemoveClosure = () -> ()
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var tappedRemove: TappedRemoveClosure?
    
    override var task: Task! {
        didSet {
            if let notify = self.task.notify {
                self.timeLabel.text = notify.date.timeString + "に通知"
                self.dateLabel.text = notify.date.dateString
            } else {
                self.timeLabel.text = "なし"
                self.dateLabel.text = ""
            }
        }
    }
    
    @IBAction private func didTapRemoveButton() {
        self.tappedRemove?()
    }
}
