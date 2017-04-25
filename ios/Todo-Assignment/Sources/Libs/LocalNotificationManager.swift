// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

class LocalNotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    func add(title: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = "Hello World"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date.components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "!", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(2)
    }
}

extension App {
    
    static let LocalNotify = LocalNotificationManager()
}

/*
// UNMutableNotificationContent 作成
let content = UNMutableNotificationContent()
content.title = "Hello!"
content.body = "World!"
content.sound = UNNotificationSound.default()

// 5秒後に発火する UNTimeIntervalNotificationTrigger 作成、
let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)

// identifier, content, trigger から UNNotificationRequest 作成
let request = UNNotificationRequest.init(identifier: "FiveSecondNotification", content: content, trigger: trigger)

// UNUserNotificationCenter に request を追加
let center = UNUserNotificationCenter.current()
center.add(request)
*/
/*
private func addLocalNotificationToSystem(notification: DBLocalNotification) {
    let ln = UILocalNotification()
    ln.alertTitle = notification.title
    ln.alertBody  = notification.content
    ln.fireDate   = notification.notifyDatetime
    ln.soundName  = UILocalNotificationDefaultSoundName
    ln.userInfo   = [
        self.IDKey   : notification.stringIdentifier,
        self.TypeKey : notification.typeIdentifier,
    ]
    // バッチは仕様ドロップ
    //        ln.applicationIconBadgeNumber = 1
    if (notification.type == .Event) {
        // 予定の場合は繰り返しがあれば繰り返す
        if (notification.isRepeat) {
            // 繰り返しの場合
            switch notification.repeatType {
            case DBLocalNotificationRepeatType.YEAR.rawValue:
                ln.repeatInterval = NSCalendarUnit.Year
                break
            case DBLocalNotificationRepeatType.MONTH.rawValue:
                ln.repeatInterval = NSCalendarUnit.Month
                break
            case DBLocalNotificationRepeatType.WEEK.rawValue:
                ln.repeatInterval = NSCalendarUnit.Weekday
                break
            case DBLocalNotificationRepeatType.DAY.rawValue:
                ln.repeatInterval = NSCalendarUnit.Day
                break
            default:
                break
            }
        }
    }
    
    UIApplication.sharedApplication().scheduleLocalNotification(ln)
}
*/
