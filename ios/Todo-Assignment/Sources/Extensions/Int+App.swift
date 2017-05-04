// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

public extension Int {
    
    /// 指定した範囲の中から乱数を取得する
    /// - parameter min: 最小値
    /// - parameter max: 最大値
    /// - returns: 乱数
    public static func random(min n: Int, max x: Int) -> Int {
        let min = n < 0 ? 0 : n
        let max = x + 1
        let v = UInt32(max < min ? 0 : max - min)
        let r = Int(arc4random_uniform(v))
        return min + r
    }
}
