// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

extension Date {
    
    static func today() -> Date {
        return Date().zeroClock()
    }
    
    private func zeroClock() -> Date {
        var comps = DateComponents()
        comps.year   = self.calendar.component(.year, from: self)
        comps.month  = self.calendar.component(.month, from: self)
        comps.day    = self.calendar.component(.day, from: self)
        comps.hour   = 0
        comps.minute = 0
        comps.second = 0
        return self.calendar.date(from: comps)!
    }
    
    private var calendar: Calendar {
        return Calendar(identifier: .gregorian)
    }
    
    private func dateFormatter(_ format: String) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.calendar   = self.calendar
        fmt.dateFormat = format
        fmt.locale     = Locale.current
        fmt.timeZone   = TimeZone.current
        return fmt
    }
    
    var description: String {
        return self.dateFormatter("yyyy/MM/dd HH:mm:ss").string(from: self)
    }
}

/*
public extension NBDate {
    
    /// 日付文字列
    public var string: String {
        return self.string(NBDate.defaultOutputFormat)
    }
    
    /// 指定した日付フォーマットから文字列を生成する
    /// - parameter format: 日付フォーマット
    /// - returns: 日付文字列
    public func string(_ format: String) -> String {
        return self.dateFormatter(format).string(from: self.date)
    }
    
    /// 指定した日付フォーマットから日付フォーマッタを生成する
    /// - parameter format: 日付フォーマット
    /// - returns: 日付フォーマッタ
    public func dateFormatter(_ format: String) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.calendar   = self.calendar
        fmt.dateFormat = format
        fmt.locale     = Locale.current
        fmt.timeZone   = TimeZone.current
        return fmt
    }
    
    public var description: String { return self.string }
}
*/
