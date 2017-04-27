// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - 汎用関数 -

/// オプショナルの値も渡せるprint関数
/// - parameter items: 値(可変長引数)
/// - parameter separator: セパレータ文字
/// - parameter terminator: 終了文字
func print(_ items: Any?..., separator: String = ", ", terminator: String = "\n") {
    for (i, item) in items.enumerated() {
        let t = (i == items.indices.last!) ? terminator : separator
        print(item ?? NSNull(), terminator: t)
    }
}

/// メインスレッド(キュー)との同期をとって処理を実行する
/// - parameter block: メインスレッドで行う処理
func onMainThread(_ block: @escaping () -> ()) {
    DispatchQueue.main.async(execute: block)
}

/// 新しいスレッド(キュー)との同期をとって処理を実行する
/// - parameter block: 新しいスレッドで行う処理
func onNewThread(_ block: @escaping () -> ()) {
    DispatchQueue.global(qos: .default).async(execute: block)
}

/// 非同期処理を行う
/// - parameter async: 非同期処理(別スレッドで実行する処理)
/// - parameter completed: 非同期処理完了時に行う処理
func async(async asynchronousProcess: @escaping () -> (), completed completionHandler: @escaping () -> ()) {
    onNewThread {
        asynchronousProcess()
        onMainThread {
            completionHandler()
        }
    }
}

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
    
    /// 指定した文字数のランダムな文字列を生成する
    /// - parameter length: タイトル
    /// - returns: ランダムな文字列
    static func randomString(length: Int) -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let upperBound = UInt32(chars.characters.count)
        return String((0..<length).map { _ -> Character in
            return chars[chars.index(chars.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
        })
    }
}

// MARK: - Int拡張 -
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

/// UIButton拡張
extension UIButton {
    
    /// ボタンタイトル(通常時)
    var title: String {
        get    { return self.title(for: .normal) ?? "" }
        set(v) { self.setTitle(v, for: .normal) }
    }
    
    /// ボタン画像(通常時)
    var image: UIImage? {
        get    { return self.image(for: .normal) }
        set(v) { self.setImage(v, for: .normal) }
    }
}

