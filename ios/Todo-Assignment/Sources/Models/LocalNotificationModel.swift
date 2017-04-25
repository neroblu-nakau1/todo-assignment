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
	func create(title: String, date: Date) -> Entity {
		let ret = self.create()
		ret.requestIdentifier = self.generateRequestIdentifier()
		ret.date = date
		self.manager.add(title: title, date: date, deliverIdentifier: ret.requestIdentifier)
		return ret
	}
	
	override func delete(entity: LocalNotification) {
		self.manager.remove(identifier: entity.requestIdentifier)
		super.delete(entity: entity)
	}
	
	/// deliverIdentifier用の32文字のランダムな文字列を生成する
	/// - returns: 32文字のランダムな文字列
	private func generateRequestIdentifier() -> String {
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
