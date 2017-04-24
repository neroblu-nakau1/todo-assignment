// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailTableViewPriorityCell: DetailTableViewCell {
    
    typealias PriorityChangedClosure = (Int) -> ()
    
    var priorityChanged: PriorityChangedClosure?
    
    @IBOutlet private var priorityButtons: [UIButton]!
    
    override var task: Task! {
        didSet {
            self.priority = self.task.priority
        }
    }
    
    var priority: Int = TaskModel.minimumPriority {
        didSet {
            self.removeHighlightEffect()
            for i in TaskModel.minimumPriority...TaskModel.maximumPriority {
                let button = self.viewWithTag(i) as! UIButton
                button.isSelected = (i <= self.priority)
            }
        }
    }
    
    @IBAction private func didTapPriorityButton(sender: UIButton) {
        self.priority = sender.tag
        self.priorityChanged?(self.priority)
    }
    
    private func removeHighlightEffect() {
        let selectedHighlighted = UIControlState(rawValue: UIControlState.selected.rawValue|UIControlState.highlighted.rawValue)
        for button in self.priorityButtons {
            button.setImage(button.image(for: .normal),   for: .highlighted)
            button.setImage(button.image(for: .selected), for: selectedHighlighted)
        }
    }
}
