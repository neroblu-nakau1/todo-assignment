// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// グラデーションビュー
@IBDesignable class GradientView: UIView {
    
    @IBInspectable var gradientColor: UIColor?
    
    @IBInspectable var endX: CGFloat = 1
    
    @IBInspectable var endY: CGFloat = 1
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let start = self.backgroundColor ?? UIColor.white
        let end   = self.gradientColor   ?? start
        
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = [start.cgColor, end.cgColor]
        layer.startPoint = CGPoint.zero
        layer.endPoint   = CGPoint(x: self.endX, y: self.endY)
        
        if let already = self.layer.sublayers?.first as? CAGradientLayer {
            self.layer.replaceSublayer(already, with: layer)
        } else {
            self.layer.insertSublayer(layer, at: 0)
        }
    }
}
