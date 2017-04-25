// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class LocalNotification: RealmEntity {
	
	/// 識別文字列
	dynamic var deliverIdentifier = ""
	
	/// 通知時刻
	dynamic var date = Date()
}
