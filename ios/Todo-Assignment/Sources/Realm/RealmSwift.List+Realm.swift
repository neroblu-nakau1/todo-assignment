// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import RealmSwift

// MARK: - RealmSwift.List拡張 -
public extension RealmSwift.List {
    
    public typealias Entity = Element
    
    /// 自身のデータを配列に変換する
    /// - returns: 変換された配列
    public var list: [Entity] {
        return self.map { return $0 }
    }
    
    /// 自身のデータを渡された配列でリセットする
    /// - parameter array: 配列
    public func reset(_ array: [Entity] = []) {
        self.removeAll()
        self.append(objectsIn: array)
    }
}
