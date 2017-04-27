// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

/// システムのローカル通知を管理するクラス
class NotificationManager: NSObject {
    
    /// 登録処理の実行結果
    class RegistrationResult {
        
        /// 成功したかどうか
        let ok: Bool
        
        /// エラーメッセージ
        let message: String
        
        /// イニシャライザ
        /// - parameter message: メッセージ
        /// - parameter fireDate: 発火する日付
        init(ok: Bool, message: String = "") {
            self.ok      = ok
            self.message = message
        }
    }
    
    static let RegisteredNotification = NSNotification.Name("NotificationManager.DidRegister")
    static let RegistrationResultKey = "result"
    
    fileprivate let taskIDKey = "taskID"
    
    let maximumNumberOfRegistrations = 64
    
    /// ローカル通知を登録する
    /// - parameter message: メッセージ
    /// - parameter fireDate: 発火する日付
    /// - parameter requestIdentifier: リクエストID
    /// - parameter taskID: タスクID
    func add(message: String, fireDate: Date, requestIdentifier: String, taskID: Int) {
        self.center.removeAllDeliveredNotifications()
        self.center.requestAuthorization(options: [.badge, .alert, .sound]) { [unowned self] grant, error in
            if !grant {
                self.postRegistrationResult(error: "通知の許可がないので登録できません")
                return
            }
            
            if let error = error {
                self.postRegistrationResult(error: "エラーが発生したため登録できません: " + error.localizedDescription)
                return
            }
            
            self.center.getPendingNotificationRequests() { [unowned self] requests in
                if requests.count >= self.maximumNumberOfRegistrations {
                    self.postRegistrationResult(error: "通知の上限数に達しているので登録できません")
                    return
                }
                
                let content = UNMutableNotificationContent()
                content.title    = fireDate.timeString
                content.body     = message
                content.sound    = UNNotificationSound.default()
                content.badge    = 1
                content.userInfo = [self.taskIDKey: taskID]
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate.components, repeats: false)
                let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
                
                self.center.delegate = self
                self.center.add(request) { [unowned self] error in
                    if let error = error {
                        self.postRegistrationResult(error: "エラーが発生したため登録できません: " + error.localizedDescription)
                        return
                    }
                    self.postRegistrationResultSucceed()
                }
            }
        }
    }
    
    /// 指定したリクエストIDのローカル通知をすべて削除する
    /// - parameter requsetIdentifiers: リクエストIDの配列
    func remove(requsetIdentifiers: [String]) {
        self.center.removePendingNotificationRequests(withIdentifiers: requsetIdentifiers)
    }
    
    /// 指定したリクエストIDのローカル通知を削除する
    /// - parameter requsetIdentifier: リクエストID
    func remove(requsetIdentifier: String) {
        self.remove(requsetIdentifiers: [requsetIdentifier])
    }
    
    /// 登録したすべてのローカル通知を削除する
    func removeAll() {
        self.center.removeAllPendingNotificationRequests()
    }
    
    func printPendigns() {
        self.center.getPendingNotificationRequests() { requests in
            for request in requests {
                print("\(request.content.title) \(request.content.body)")
            }
        }
    }
    
    func printDelivered() {
        self.center.getDeliveredNotifications() { notifications in
            for notification in notifications {
                print("\(notification.request.content.title) \(notification.request.content.body)")
            }
        }
    }

    /// ローカル通知登録の監視を開始する
    /// - parameter observer: オブザーバ
    /// - parameter selector: セレクタ
    class func startObserveRegister(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: self.RegisteredNotification,
            object: nil
        )
    }
    
    /// ローカル通知登録の監視を開始する
    /// - parameter requsetIdentifier: リクエストID
    class func stopObserveRegister(_ observer: Any) {
        NotificationCenter.default.removeObserver(
            observer,
            name: self.RegisteredNotification,
            object: nil
        )
    }
    
    /// UNUserNotificationCenter.current()のラッププロパティ
    private var center: UNUserNotificationCenter {
        return UNUserNotificationCenter.current()
    }
    
    private func postRegistrationResult(error: String) {
        NotificationCenter.default.post(
            name:     NotificationManager.RegisteredNotification,
            object:   nil,
            userInfo: [
                NotificationManager.RegistrationResultKey : RegistrationResult(ok: false, message: error)
            ]
        )
    }
    
    private func postRegistrationResultSucceed() {
        NotificationCenter.default.post(
            name:     NotificationManager.RegisteredNotification,
            object:   nil,
            userInfo: [
                NotificationManager.RegistrationResultKey : RegistrationResult(ok: true)
            ]
        )
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard
            let taskID = response.notification.request.content.userInfo[self.taskIDKey] as? Int,
            let task = App.Model.Task.select(id: taskID)
            else
        {
            completionHandler()
            return
        }
        
        App.Model.Task.updateNotify(task, to: nil)
        NotificationCenter.default.post(name: ListViewController.ReloadNotification, object: nil)
        NotificationCenter.default.post(name: DetailViewController.ReloadNotification, object: nil)
        completionHandler()
    }
}
