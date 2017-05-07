// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 詳細画面用テーブルセル: 日付(期限)
class DetailTableViewDateCell: DetailTableViewCell {
    
    @IBOutlet fileprivate weak var captionLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    
    override weak var task: Task! {
        didSet {
            self.dateLabel.text = self.task.date.dateString
        }
    }
}
