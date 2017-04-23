// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - String拡張: Realm用 -
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
}
