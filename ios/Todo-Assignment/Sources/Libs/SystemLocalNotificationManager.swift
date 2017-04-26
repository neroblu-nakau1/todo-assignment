// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

/// システムのローカル通知を管理するクラス
class SystemLocalNotificationManager: NSObject {
    
    class RegistrationResult {
        
        let ok: Bool
        let message: String
        
        init(ok: Bool, message: String = "") {
            self.ok      = ok
            self.message = message
        }
    }
    
    static let RegisteredNotification = NSNotification.Name("SystemLocalNotificationManager.DidRegister")
    static let RegistrationResultKey = "result"
    static let TaskIDKey = "taskID"
    
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
                content.userInfo = [SystemLocalNotificationManager.TaskIDKey: taskID]
                
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
            name:     SystemLocalNotificationManager.RegisteredNotification,
            object:   nil,
            userInfo: [
                SystemLocalNotificationManager.RegistrationResultKey : RegistrationResult(ok: false, message: error)
            ]
        )
    }
    
    private func postRegistrationResultSucceed() {
        NotificationCenter.default.post(
            name:     SystemLocalNotificationManager.RegisteredNotification,
            object:   nil,
            userInfo: [
                SystemLocalNotificationManager.RegistrationResultKey : RegistrationResult(ok: true)
            ]
        )
    }
}

extension SystemLocalNotificationManager: UNUserNotificationCenterDelegate {

}
/*
extension LocalNotificationManeger: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .sound, .badge])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let requestIdentifier = response.notification.request.identifier
		
		
		
		
		
//		self.center.getDeliveredNotifications(completionHandler: { i in print(i) })
//		
//		UIApplication.shared.delegate?.window??.rootViewController = ListViewController.create()
//		
//		print(response.notification.request.content.userInfo)
//		
		completionHandler()
	}
}
*/
