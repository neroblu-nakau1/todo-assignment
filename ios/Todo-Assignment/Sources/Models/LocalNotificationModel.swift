// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

class LocalNotificationModel: RealmModel<LocalNotification> {
	
	let manager = SystemLocalNotificationManager()
	
	/// 新しいエンティティを生成する
    /// - parameter task: タスク
	/// - parameter date: 通知日時
	/// - returns: 新しいエンティティ
	func create(task: Task, date: Date) -> Entity {
		let ret = self.create()
        let requestIdentifier = String.randomString(length: 32)
		ret.requestIdentifier = requestIdentifier
		ret.date = date
        self.manager.add(message: task.title, fireDate: date, requestIdentifier: requestIdentifier, taskID: task.id)
		return ret
	}
	
    /// エンティティを削除する
    /// - parameter entity: エンティティ
	override func delete(entity: LocalNotification) {
		self.manager.remove(requsetIdentifier: entity.requestIdentifier)
		super.delete(entity: entity)
	}
}

// MARK: - App.Model拡張 -
extension App.Model {
	
	/// タスクモデル
	static let LocalNotification = LocalNotificationModel()
}
