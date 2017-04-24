// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class DetailTableViewDeleteCell: DetailTableViewCell {
    
    typealias TappedDeleteClosure = () -> ()
    
    var tappedDelete: TappedDeleteClosure?
    
    @IBAction private func didTapDeleteButton() {
        self.tappedDelete?()
    }
}
