// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import UserNotifications

class LocalNotificationModel: RealmModel<LocalNotification> {
	
	let manager = LocalNotificationManeger()
	
	/// 新しいエンティティを生成する
	/// - parameter date: 日付
	/// - parameter withID: エンティティに与えるID(省略時は自動的に採番)
	/// - returns: 新しいエンティティ
	func create(date: Date, withID id: Int64? = nil) -> Entity {
		let ret = self.create(withID: id)
		ret.deliverIdentifier = self.generateDeliverIdentifier()
		ret.date = date
		return ret
	}
	
	func removeNotification(_ entity: Entity) {
		self.manager.remove(identifier: entity.deliverIdentifier)
	}
	
	/// deliverIdentifier用の32文字のランダムな文字列を生成する
	/// - returns: 32文字のランダムな文字列
	private func generateDeliverIdentifier() -> String {
		let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let upperBound = UInt32(chars.characters.count)
		return String((0..<32).map { _ -> Character in
			return chars[chars.index(chars.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
		})
	}
}

// MARK: - App.Model拡張 -
extension App.Model {
	
	/// タスクモデル
	static let LocalNotification = LocalNotificationModel()
}
