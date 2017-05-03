// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import SVProgressHUD

/// HUDを扱うクラス
class Hud {
    
    /// HUDを表示する
    /// - parameter message: メッセージ
    class func show(_ message: String? = nil) {
        if self.isShow { return }
        
        if !self.isFinishedSetup {
            self.setup()
            self.isFinishedSetup = true
        }
        
        self.isEnabledTouches = false
        if let message = message {
			
            SVProgressHUD.show(withStatus: message)
        } else {
            SVProgressHUD.show()
        }
    }
    
    /// HUDを非表示にする
	class func hide(_ message: String? = nil) {
		if let msg = message {
			SVProgressHUD.showInfo(withStatus: msg)
		}
		SVProgressHUD.dismiss(withDelay: 1) { 
			self.isEnabledTouches = true
		}
    }
    
    /// HUDを表示しているかどうか
    class var isShow: Bool {
        return SVProgressHUD.isVisible()
    }
    
    private static var isEnabledTouches = true {
        didSet {
            if self.isEnabledTouches {
                UIApplication.shared.endIgnoringInteractionEvents()
            } else {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }
    
    private static var isFinishedSetup = false
    
    private class func setup() {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setRingThickness(4.0)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        SVProgressHUD.setFont(UIFont.preferredFont(forTextStyle: .subheadline))
    }
}
