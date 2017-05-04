// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

// MARK: - ローカル通知エンティティモデル -
class LocalNotificationModel: RealmModel<LocalNotification> {
	
    /// ローカル通知マネージャ
	let manager = NotificationManager()
	
	/// 新しいエンティティを生成する
    /// - parameter task: タスク
	/// - parameter date: 通知日時
	/// - returns: 新しいエンティティ(dateがnilの場合はnilが返る)
	func create(task: Task, date: Date?) -> Entity? {
        guard let date = date else {
            return nil
        }
		let ret = self.create()
        let requestIdentifier = String.randomString(length: 32)
		ret.requestIdentifier = requestIdentifier
		ret.date = date
        self.manager.add(message: task.title, fireDate: date, requestIdentifier: requestIdentifier, taskID: task.id)
		return ret
	}
    
    /// 指定したエンティティを削除する
    /// - parameter entity: エンティティ
    override func delete(_ entity: LocalNotification) {
        self.manager.remove(requsetIdentifier: entity.requestIdentifier)
        super.delete(entity)
    }
    
    /// 指定した複数のエンティティを削除する
    /// - parameter entities: エンティティ
    override func delete(_ entities: [LocalNotification]) {
        let requsetIdentifiers = entities.map { $0.requestIdentifier }
        self.manager.remove(requsetIdentifiers: requsetIdentifiers)
        super.delete(entities)
    }
}

// MARK: - App.Model拡張 -
extension App.Model {
	
	/// ローカル通知エンティティモデル
	static let LocalNotification = LocalNotificationModel()
}
