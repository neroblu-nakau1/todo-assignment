// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

class LocalNotificationManeger: NSObject {
	
	func add(title: String, date: Date) {
		self.center.removeAllDeliveredNotifications()
		self.center.requestAuthorization(options: [.badge, .alert, .sound]) { grant, error in
			if !grant || error != nil {
				print("だめ")
			}
			
			let content = UNMutableNotificationContent()
			content.title    = date.timeString
			content.body     = title
			content.sound    = UNNotificationSound.default()
			content.badge    = 1
			content.userInfo = ["id": 1]
			
			let trigger = UNCalendarNotificationTrigger(dateMatching: date.components, repeats: false)
			let request = UNNotificationRequest(identifier: "LocalNotify", content: content, trigger: trigger)
			
			self.center.delegate = self
			self.center.add(request, withCompletionHandler: nil)
		}
	}
	
	/// UNUserNotificationCenter.current()のラッププロパティ
	fileprivate var center: UNUserNotificationCenter {
		return UNUserNotificationCenter.current()
	}
	
	
	
	func remove(identifiers: [String]) {
		self.center.removeDeliveredNotifications(withIdentifiers: identifiers)
	}
	
	func remove(identifier: String) {
		self.remove(identifiers: [identifier])
	}
}

extension LocalNotificationManeger: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([.alert, .sound, .badge])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		
		
		
		self.center.getDeliveredNotifications(completionHandler: { i in print(i) })
		
		UIApplication.shared.delegate?.window??.rootViewController = ListViewController.create()
		
		print(response.notification.request.content.userInfo)
		
		completionHandler()
	}
}
