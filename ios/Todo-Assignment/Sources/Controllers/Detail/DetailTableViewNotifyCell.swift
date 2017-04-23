// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailTableViewNotifyCell: DetailTableViewCell {
    
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    
    override var task: Task! {
        didSet {
            if let notifyDate = self.task.notifyDate {
                self.timeLabel.text = notifyDate.dateString + "に通知"
                self.dateLabel.text = notifyDate.dateString
            } else {
                self.timeLabel.text = "なし"
                self.dateLabel.text = ""
            }
        }
    }
}
