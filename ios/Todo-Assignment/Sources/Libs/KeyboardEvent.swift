// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class KeyboardEventManager: NSObject {
    
    typealias ChangingClosure = (CGFloat) -> Void
    
    var changing: ChangingClosure?
    
    fileprivate var keyboardHeight: CGFloat = CGFloat.leastNormalMagnitude
    fileprivate var keyboardY:      CGFloat = CGFloat.leastNormalMagnitude
    
    /// イニシャライザ
    /// - parameter changing: キーボードの座標変更時のアニメーション実行時に呼ばれるクロージャ
    public init(_ changing: ChangingClosure?) {
        super.init()
        self.observeKeyboardEvents(true)
        self.changing = changing
    }
    
    deinit {
        self.observeKeyboardEvents(false)
    }
    
    // MARK: プライベート
    
    fileprivate func observeKeyboardEvents(_ start: Bool) {
        let selector = "willChangeKeyboardFrame:"
        
        if start {
            self.keyboardHeight = CGFloat.leastNormalMagnitude
            self.keyboardY      = CGFloat.leastNormalMagnitude
        }
        
        let center = NotificationCenter.default
        let notificationsAndSelectors = [
            NSNotification.Name.UIKeyboardWillShow.rawValue        : selector,
            NSNotification.Name.UIKeyboardWillChangeFrame.rawValue : selector,
            NSNotification.Name.UIKeyboardWillHide.rawValue        : selector,
            ]
        for e in notificationsAndSelectors {
            if start {
                center.addObserver(self, selector: Selector(e.value), name: NSNotification.Name(rawValue: e.key), object: nil)
            } else {
                center.removeObserver(self, name: NSNotification.Name(rawValue: e.key), object: nil)
            }
        }
    }
    
    @objc fileprivate func willChangeKeyboardFrame(_ notify: Notification) {
        guard
            let userInfo   = notify.userInfo,
            let beginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as AnyObject).cgRectValue,
            let endFrame   = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
            let curve      = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            let duration   = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            else {
                return
        }
        
        // 初回のみ
        if self.keyboardHeight == CGFloat.leastNormalMagnitude && self.keyboardY == CGFloat.leastNormalMagnitude {
            self.keyboardHeight = beginFrame.height
            self.keyboardY      = beginFrame.minY
        }
        
        let height = endFrame.height
        let endY   = endFrame.minY
        
        // 別画面でキーボードを表示すると変数yに大きな整数が入ってしまうため
        if endY > self.screenHeight * 2 { return }
        
        // 高さもY座標も変化していない場合は処理抜け
        if self.keyboardHeight == height && self.keyboardY == endY { return }
        
        self.keyboardHeight = height
        self.keyboardY      = endY
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIViewAnimationOptions(rawValue: UInt(curve)),
            animations: {
                let distance = self.screenHeight - endY
                self.changing?(distance)
        },
            completion: nil
        )
    }
    
    private var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
}
