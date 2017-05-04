// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - String拡張 -
extension String {
    
    /// Realm用にエスケープした文字列
    var realmEscaped: String {
        let replaces = [
            "\\" : "\\\\",
            "'"  : "\\'",
            ]
        var ret = self
        for replace in replaces {
            ret = self.replacingOccurrences(of: replace.key, with: replace.value)
        }
        return ret
    }
    
    /// 指定した文字列長のランダムな文字列を生成する
    /// - parameter length: 文字列長
    /// - returns: ランダムな文字列
    static func randomString(length: Int) -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let upperBound = UInt32(chars.characters.count)
        return String((0..<length).map { _ -> Character in
            return chars[chars.index(chars.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
        })
    }
}
