// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

/// システムのローカル通知を管理するクラス
class SystemLocalNotificationManager: NSObject {
    
    
}

extension SystemLocalNotificationManager: UNUserNotificationCenterDelegate {
    
}

/*
class LocalNotificationManeger: NSObject {
	
	func add(title: String, date: Date, deliverIdentifier: String) {
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
			let request = UNNotificationRequest(identifier: deliverIdentifier, content: content, trigger: trigger)
			
			self.center.delegate = self
			self.center.add(request) { err in
				print(err)
			}
		}
	}
	
	/// UNUserNotificationCenter.current()のラッププロパティ
	fileprivate var center: UNUserNotificationCenter {
		return UNUserNotificationCenter.current()
	}
	
	func removeAll() {
		self.center.removeAllPendingNotificationRequests()
	}
	
	func remove(identifiers: [String]) {
		self.center.removePendingNotificationRequests(withIdentifiers: identifiers)
	}
	
	func remove(identifier: String) {
		self.remove(identifiers: [identifier])
	}
	
	func printDelivered() {
		self.center.getDeliveredNotifications() { arr in
			arr.forEach { print($0.request.content.body, $0.request.identifier) }
		}
	}
	
	func printPending() {
		self.center.getPendingNotificationRequests() { arr in
			arr.forEach { print($0.content.body, $0.identifier, $0.content.title) }
		}
	}
}

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
