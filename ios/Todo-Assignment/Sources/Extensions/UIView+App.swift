// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

extension UIView {
    
    /// 枠線の幅
    @IBInspectable var borderWidth: CGFloat {
        get    { return self.layer.borderWidth }
        set(v) { self.layer.borderWidth = v }
    }
    
    /// 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = self.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set(v) { self.layer.borderColor = v?.cgColor }
    }
    
    /// 角丸
    @IBInspectable var cornerRadius: CGFloat {
        get    { return self.layer.cornerRadius }
        set(v) { self.layer.cornerRadius = v }
    }
    
    public func setGradient(color1: UIColor, color2: UIColor) {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 20, y: 20, width: 20, height: 20)//self.bounds
        layer.colors = [color1.cgColor, color2.cgColor]
        layer.startPoint = CGPoint.zero
        layer.endPoint = CGPoint(x: 1, y: 1)
        
        self.layer.insertSublayer(layer, at: 0)
    }
}
