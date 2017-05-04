// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 詳細画面: メモセル
class DetailTableViewMemoCell: DetailTableViewCell {
    
    @IBOutlet fileprivate weak var memoLabel: UILabel!
    
    override var task: Task! {
        didSet {
            let fill = !self.task.memo.isEmpty
            
            self.memoLabel.text      = fill ? self.task.memo : "メモを入力…"
            self.memoLabel.textColor = fill ? UIColor.darkText : UIColor.lightGray
        }
    }
}
