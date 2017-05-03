// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - NSPredicate拡張: イニシャライザ(ID) -
extension NSPredicate {
    
    /// イニシャライザ: ID指定の条件を生成する
    /// - parameter ids: IDの配列
    convenience init(ids: [Int]) {
        let arr = ids.map { NSNumber(value: $0 as Int) }
        self.init(format: "\(RealmEntity.idKey) IN %@", argumentArray: [arr])
    }
    
    /// イニシャライザ ID指定の条件を生成する
    /// - parameter id: ID
    convenience init(id: Int) {
        self.init(format: "\(RealmEntity.idKey) = %@", argumentArray: [NSNumber(value: id as Int)])
    }
}

// MARK: - NSPredicate拡張: イニシャライザ(式) -
extension NSPredicate {
    
    private convenience init(expression property: String, _ operation: String, _ value: Any) {
        self.init(format: "\(property) \(operation) %@", argumentArray: [value])
    }
    
    /// イニシャライザ: "プロパティ = 値" の条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter value: 値
    convenience init(_ property: String, equal value: Any) {
        self.init(expression: property, "=", value)
    }
	
    /// イニシャライザ: "プロパティ != 値" の条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter value: 値
    convenience init(_ property: String, notEqual value: Any) {
        self.init(expression: property, "!=", value)
    }
    
    /// イニシャライザ: "プロパティ >= 値" の条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter value: 値
    convenience init(_ property: String, equalOrGreaterThan value: Any) {
        self.init(expression: property, ">=", value)
    }
    
    /// イニシャライザ: "プロパティ <= 値" の条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter value: 値
    convenience init(_ property: String, equalOrLessThan value: Any) {
        self.init(expression: property, "<=", value)
    }
    
    /// イニシャライザ: "プロパティ > 値" の条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter value: 値
    convenience init(_ property: String, greaterThan value: Any) {
        self.init(expression: property, ">", value)
    }
    
    /// イニシャライザ: "プロパティ < 値" の条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter value: 値
    convenience init(_ property: String, lessThan value: Any) {
        self.init(expression: property, "<", value)
    }
}

// MARK: - NSPredicate拡張: イニシャライザ(文字列(LIKE)検索) -
extension NSPredicate {
    
    /// イニシャライザ: 文字列検索条件を生成する。文字列がどこかに含まれていればヒットする
    /// - warning: String型のフィールドである必要がある
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter q: 値
    convenience init(_ property: String, contains q: String) {
        self.init(format: "\(property) CONTAINS '\(q)'")
    }
    
    /// イニシャライザ: 文字列検索条件を生成する。文字列が先頭に含まれていればヒットする
	/// - warning: String型のフィールドである必要がある
	/// - parameter property: プロパティ(フィールド)名
	/// - parameter q: 値
    convenience init(_ property: String, beginsWith q: String) {
        self.init(format: "\(property) BEGINSWITH '\(q)'")
    }
    
	/// イニシャライザ: 文字列検索条件を生成する。文字列が末尾に含まれていればヒットする
	/// - warning: String型のフィールドである必要がある
	/// - parameter property: プロパティ(フィールド)名
	/// - parameter q: 値
    convenience init(_ property: String, endsWith q: String) {
        self.init(format: "\(property) ENDSWITH '\(q)'")
    }
}

// MARK: - NSPredicate拡張: イニシャライザ(IN句) -
extension NSPredicate {
    
    /// イニシャライザ: IN句検索条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter values: 値の配列
    convenience init(_ property: String, valuesIn values: [Any]) {
        self.init(format: "\(property) IN %@", argumentArray: [values])
    }
}

// MARK: - NSPredicate拡張: イニシャライザ(BETWEEN句) -
extension NSPredicate {
    
    /// イニシャライザ: BETWEEN句検索条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter min: 最小値
    /// - parameter max: 最大値
    convenience init(_ property: String, between min: Any, to max: Any) {
        self.init(format: "\(property) BETWEEN {%@, %@}", argumentArray: [min, max])
    }
    
    /// イニシャライザ: 日時範囲条件を生成する
    /// - warning: Date(NSDate)型のフィールドである必要がある。fromDate と toDate 両方に nil を渡すことは推奨されない
    /// - parameter property: プロパティ(フィールド)名
    /// - parameter fromDate: From日時
    /// - parameter toDate: To日時
    convenience init(_ property: String, fromDate: Date?, toDate: Date?) {
        var format = "", args = [Any]()
        if let from = fromDate {
            format += "\(property) >= %@"
            args.append(from)
        }
        if let to = toDate {
            if !format.isEmpty {
                format += " AND "
            }
            format += "\(property) <= %@"
            args.append(to)
        }
        if !args.isEmpty {
            self.init(format: format, argumentArray: args)
        } else {
            self.init(value: true)
        }
    }
}

// MARK: - NSPredicate拡張: イニシャライザ(nil比較) -
extension NSPredicate {
    
    /// イニシャライザ: nilかどうかの比較条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    convenience init(isNil property: String) {
        self.init(format: "\(property) == nil", argumentArray: nil)
    }
    
    /// イニシャライザ: nilでないかどうかの比較条件を生成する
    /// - parameter property: プロパティ(フィールド)名
    convenience init(isNotNil property: String) {
        self.init(format: "\(property) != nil", argumentArray: nil)
    }
}

// MARK: - NSPredicate拡張: イニシャライザ(集計用) -
extension NSPredicate {
    
    /// ANY句を加えた条件を返す
    /// - parameter objectName: オブジェクト名
    func any(of objectName: String) -> NSPredicate {
        let format = "ANY \(objectName)." + self.predicateFormat
        return NSPredicate(format: format)
    }
}

// MARK: - NSPredicate拡張: コンパウンド(条件結合) -
extension NSPredicate {
    
    /// 常にTRUEとなるNSPredicateを返します(空の条件)
    static var empty: NSPredicate {
		return NSPredicate(value: true)
	}
    
    /// 常にFALSEとなるNSPredicateを返す
    static var dead: NSPredicate {
		return NSPredicate(value: false)
	}
    
    /// AND条件結合したNSPredicateを返す
    /// - parameter predicate: NSPredicateオブジェクト
    /// - returns: 条件結合したNSPredicate
    func and(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound([predicate], type: .and)
    }
    
	/// OR条件結合したNSPredicateを返す
	/// - parameter predicate: NSPredicateオブジェクト
    /// - returns: 条件結合したNSPredicate
    func or(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound([predicate], type: .or)
    }
    
	/// 条件結合したNSPredicateを返す
	/// - parameter predicate: NSPredicateオブジェクト
    /// - returns: 条件結合したNSPredicate
    func not(_ predicate: NSPredicate) -> NSPredicate {
        return self.compound([predicate], type: .not)
    }
    
    /// 条件結合したNSPredicateを返す
    /// - parameter predicates: NSPredicateの配列
    /// - parameter type: 結合の種別
    /// - returns: 条件結合したNSPredicate
    func compound(_ predicates: [NSPredicate], type: NSCompoundPredicate.LogicalType = .and) -> NSPredicate {
        var p = predicates; p.insert(self, at: 0)
        switch type {
        case .and: return NSCompoundPredicate(andPredicateWithSubpredicates: p)
        case .or:  return NSCompoundPredicate(orPredicateWithSubpredicates:  p)
        case .not: return NSCompoundPredicate(notPredicateWithSubpredicate:  self.compound(p))
        }
    }
}
