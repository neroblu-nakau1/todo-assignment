// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 詳細画面用テーブルセル: 重要度
class DetailTableViewPriorityCell: DetailTableViewCell {
    
    typealias PriorityChangedClosure = (Int) -> ()
    
    var priorityChanged: PriorityChangedClosure?
    
    @IBOutlet private var priorityButtons: [UIButton]!
    
    override weak var task: Task! {
        didSet {
            self.priority = self.task.priority
        }
    }
    
    /// 重要度
    var priority: Int = TaskModel.minimumPriority {
        didSet {
            self.removeHighlightEffect()
            for i in TaskModel.minimumPriority...TaskModel.maximumPriority {
                let button = self.viewWithTag(i) as! UIButton
                button.isSelected = (i <= self.priority)
            }
        }
    }
    
    /// 重要度ボタン(星)押下時
    /// - parameter sender: 押下されたボタン
    @IBAction private func didTapPriorityButton(sender: UIButton) {
        self.priority = sender.tag
        self.priorityChanged?(self.priority)
    }
    
    /// 自動的にハイライト画像が設定されるのを防ぐ
    private func removeHighlightEffect() {
        let selectedHighlighted = UIControlState(rawValue: UIControlState.selected.rawValue|UIControlState.highlighted.rawValue)
        for button in self.priorityButtons {
            button.setImage(button.image(for: .normal),   for: .highlighted)
            button.setImage(button.image(for: .selected), for: selectedHighlighted)
        }
    }
}
