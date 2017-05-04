// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 詳細画面: 削除セル
class DetailTableViewDeleteCell: DetailTableViewCell {
    
    typealias TappedDeleteClosure = () -> ()
    
    /// 削除ボタン押下時コールバック
    var tappedDelete: TappedDeleteClosure?
    
    /// 削除ボタン押下時
    @IBAction private func didTapDeleteButton() {
        self.tappedDelete?()
    }
}
