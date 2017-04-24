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
            if let notifyDate = self.task.notifyDate {
                self.timeLabel.text = notifyDate.timeString + "に通知"
                self.dateLabel.text = notifyDate.dateString
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
