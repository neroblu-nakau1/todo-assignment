// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

extension Date {
	
	/// 各日時情報から新しいDateオブジェクトを生成する
	/// - parameter year: 年
	/// - parameter month: 月
	/// - parameter day: 日
	/// - parameter hour: 時
	/// - parameter minute: 分
	/// - parameter second: 秒
	/// - returns: 新しいDateオブジェクト
	static func create(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
		let now = Date()
		var comps = DateComponents()
		comps.year   = year   ?? now.year
		comps.month  = month  ?? now.month
		comps.day    = day    ?? now.day
		comps.hour   = hour   ?? now.hour
		comps.minute = minute ?? now.minute
		comps.second = second ?? now.second
		return self.calendar.date(from: comps)!
	}
		
	/// 各日付時刻情報に値を追加して新しいDateオブジェクトを生成する
	/// - parameter year: 追加する年数
	/// - parameter month: 追加する月数
	/// - parameter day: 追加する日数
	/// - parameter hour: 追加する時数
	/// - parameter minute: 追加する分数
	/// - parameter second: 追加する秒数
	/// - returns: 新しいDateオブジェクト
	func added(year: Int = 0, month: Int = 0, day: Int = 0, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
		var comps = DateComponents()
		comps.year   = self.year   + year
		comps.month  = self.month  + month
		comps.day    = self.day    + day
		comps.hour   = self.hour   + hour
		comps.minute = self.minute + minute
		comps.second = self.second + second
		return self.calendar.date(from: comps)!
	}
	
	/// 各日付時刻情報に値をセットして新しいDateオブジェクトを生成する
	/// - parameter year: セットする年数
	/// - parameter month: セットする月数
	/// - parameter day: セットする日数
	/// - parameter hour: セットする時数
	/// - parameter minute: セットする分数
	/// - parameter second: セットする秒数
	/// - returns: 新しいDateオブジェクト
	func fixed(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) -> Date {
		var comps = DateComponents()
		comps.year   = year   ?? self.year
		comps.month  = month  ?? self.month
		comps.day    = day    ?? self.day
		comps.hour   = hour   ?? self.hour
		comps.minute = minute ?? self.minute
		comps.second = second ?? self.second
		return self.calendar.date(from: comps)!
	}
    
    /// 0時0分0病に設定された新しいDateオブジェクトを生成する
    /// - parameter addDay: 追加する日数
    /// - returns: 新しいDateオブジェクト
    func zeroClock(addDay: Int = 0) -> Date {
        return self.fixed(hour: 0, minute: 0, second: 0).added(day: addDay)
    }
    
    /// 年
    var year: Int { return self.value(of: .year) }
    
    /// 月
    var month: Int { return self.value(of: .month) }
    
    /// 日
    var day: Int { return self.value(of: .day) }
    
    /// 時
    var hour: Int { return self.value(of: .hour) }
    
    /// 分
    var minute: Int { return self.value(of: .minute) }
    
    /// 秒
    var second: Int { return self.value(of: .second) }
	
    /// 週
    var weekName: String {
        let index = self.calendar.component(.weekday, from: self) - 1
        return self.dateFormatter().shortWeekdaySymbols[index]
    }
    
    /// 今日の0時0分0秒のDateオブジェクトを生成する
    /// - returns: 新しいDateオブジェクト
    static func today() -> Date {
        return Date().zeroClock()
    }
    
    /// 明日の0時0分0秒のDateオブジェクトを生成する
    /// - returns: 新しいDateオブジェクト
    static func tomorrow() -> Date {
        return Date().zeroClock(addDay: 1)
    }
    
    /// 明後日の0時0分0秒のDateオブジェクトを生成する
    /// - returns: 新しいDateオブジェクト
    static func dayAfterTomorrow() -> Date {
        return Date().zeroClock(addDay: 2)
    }
	
    /// 日付が今日かどうか
    var isToday: Bool {
        return self.zeroClock() == Date.today()
    }
	
	/// 日付が明日かどうか
    var isTomorrow: Bool {
        return self.zeroClock() == Date.tomorrow()
    }
	
	/// 日付が明後日かどうか
    var isDayAfterTomorrow: Bool {
        return self.zeroClock() == Date.dayAfterTomorrow()
    }
	
	/// 日付が今月かどうか
    var isThisMonth: Bool {
        return self.isThisYear && self.zeroClock().month == Date().zeroClock().month
    }
	
	/// 日付が今年かどうか
    var isThisYear: Bool {
        return self.zeroClock().year == Date().zeroClock().year
    }
	
	/// 日付の表示用文字列
    var dateString: String {
        if self.isToday {
            return "今日"
        } else if self.isTomorrow {
            return "明日"
        } else if self.isDayAfterTomorrow {
            return "明後日"
        } else if self.isThisMonth {
            return "今月\(self.day)日(\(self.weekName))"
        } else if self.isThisYear {
            return self.formattedString("M月d日") + "(\(self.weekName))"
        } else {
            return self.formattedString("Y年M月d日") + "(\(self.weekName))"
        }
    }
	
	/// 時刻の表示用文字列
    var timeString: String {
        return self.formattedString("HH時mm分")
    }
	
	/// 日時の表示用文字列
	var string: String {
		return "\(self.dateString) \(self.timeString)"
	}
	
	/// フォーマット文字列に基づいた日付文字列を返す
	/// - parameter format: フォーマット文字列
	/// - returns: フォーマットされた文字列
	func formattedString(_ format: String = "") -> String {
		return self.dateFormatter(format).string(from: self)
	}
		
	/// 日付フォーマッタ
    func dateFormatter(_ format: String = "") -> DateFormatter {
        let fmt = DateFormatter()
        fmt.calendar   = self.calendar
        fmt.dateFormat = format
        fmt.locale     = Locale.current
        fmt.timeZone   = TimeZone.current
        return fmt
    }
	
	/// 日付コンポーネント
    var components: DateComponents {
        return self.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    }
    
    /// カレンダー(グレゴリアン歴)
    static var calendar: Calendar {
        return Calendar(identifier: .gregorian)
    }
    
    /// カレンダー(グレゴリアン歴)
    var calendar: Calendar {
        return Date.calendar
    }
	
	/// コンポーネント種別から値を取得する
	/// - parameter component: コンポーネント種別
	/// - returns: 新しいDateオブジェクト
	private func value(of component: Calendar.Component) -> Int {
		return self.calendar.component(component, from: self)
	}
}
