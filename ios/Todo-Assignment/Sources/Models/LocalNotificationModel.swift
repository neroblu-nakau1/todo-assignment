// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

class LocalNotificationModel: RealmModel<LocalNotification> {
	
	let manager = SystemLocalNotificationManager()
	
	/// 新しいエンティティを生成する
	/// - parameter date: 日付
	/// - parameter withID: エンティティに与えるID(省略時は自動的に採番)
	/// - returns: 新しいエンティティ
	func create(title: String, date: Date) -> Entity {
		let ret = self.create()
		ret.requestIdentifier = String.randomString(length: 32)
		ret.date = date
		self.manager.add(title: title, date: date, deliverIdentifier: ret.requestIdentifier)
		return ret
	}
	
	override func delete(entity: LocalNotification) {
		self.manager.remove(identifier: entity.requestIdentifier)
		super.delete(entity: entity)
	}
}

// MARK: - App.Model拡張 -
extension App.Model {
	
	/// タスクモデル
	static let LocalNotification = LocalNotificationModel()
}
