// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

extension Date {
    
    static func today() -> Date {
        return Date().zeroClock()
    }
    
    func zeroClock(addDay: Int = 0) -> Date {
        var comps = DateComponents()
        comps.year   = self.calendar.component(.year,  from: self)
        comps.month  = self.calendar.component(.month, from: self)
        comps.day    = self.calendar.component(.day,   from: self) + addDay
        comps.hour   = 0
        comps.minute = 0
        comps.second = 0
        return self.calendar.date(from: comps)!
    }
    
    /// 年
    var year: Int { return self.calendar.component(.year, from: self) }
    
    /// 月
    var month: Int { return self.calendar.component(.month, from: self) }
    
    /// 日
    var day: Int { return self.calendar.component(.day, from: self) }
    
    /// 時
    var hour: Int { return self.calendar.component(.hour, from: self) }
    
    /// 分
    var minute: Int { return self.calendar.component(.minute, from: self) }
    
    /// 秒
    var second: Int { return self.calendar.component(.second, from: self) }
    
    /// 週
    var week: String {
        let index = self.calendar.component(.weekday, from: self) - 1
        return self.dateFormatter("").shortWeekdaySymbols[index]
    }
    
    func localizedName(_ symbols: (DateFormatter) -> [String]!, index: Int) -> String {
        let fmt = DateFormatter()
        fmt.calendar = self.calendar
        fmt.locale = Locale.current
        return symbols(fmt)[index]
    }
    
    
    var isToday: Bool {
        return self.zeroClock() == Date().zeroClock()
    }
    
    var isTomorrow: Bool {
        return self.zeroClock() == Date().zeroClock(addDay: 1)
    }
    
    var isDayAfterTomorrow: Bool {
        return self.zeroClock() == Date().zeroClock(addDay: 2)
    }
    
    var isThisMonth: Bool {
        return self.isThisYear && self.zeroClock().month  == Date().zeroClock().month
    }
    
    var isThisYear: Bool {
        return self.zeroClock().year  == Date().zeroClock().year
    }
    
    var dateString: String {
        if self.isToday {
            return "今日"
        } else if self.isTomorrow {
            return "明日"
        } else if self.isDayAfterTomorrow {
            return "明後日"
        } else if self.isThisMonth {
            return "今月\(self.day)日(\(self.week))"
        } else if self.isThisYear {
            return self.dateFormatter("M月d日").string(from: self) + "(\(self.week))"
        } else {
            return self.dateFormatter("Y年M月d日").string(from: self) + "(\(self.week))"
        }
    }
    
    var timeString: String {
        return self.dateFormatter("HH時mm分").string(from: self)
    }
    
    static var calendar: Calendar {
        return Calendar(identifier: .gregorian)
    }
    
    private var calendar: Calendar {
        return Date.calendar
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
    
    var components: DateComponents {
        return self.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    }
}
