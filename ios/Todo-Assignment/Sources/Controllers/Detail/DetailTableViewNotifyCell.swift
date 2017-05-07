// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

///詳細画面用テーブルセル: 通知時刻
class DetailTableViewNotifyCell: DetailTableViewCell {
    
    typealias TappedRemoveClosure = () -> ()
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var removeButton: UIButton!
    
    var tappedRemove: TappedRemoveClosure?
    
    override weak var task: Task! {
        didSet {
            if let notify = self.task.notify {
                self.timeLabel.text = notify.date.timeString + "に通知"
                self.dateLabel.text = notify.date.dateString
                self.removeButton.isHidden = false
            } else {
                self.timeLabel.text = "なし"
                self.dateLabel.text = ""
                self.removeButton.isHidden = true
            }
        }
    }
    
    /// 通知削除ボタン押下時
    @IBAction private func didTapRemoveButton() {
        self.tappedRemove?()
    }
}
