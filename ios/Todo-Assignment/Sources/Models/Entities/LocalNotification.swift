// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class LocalNotification: RealmEntity {
	
	/// リクエストID
	dynamic var requestIdentifier = ""
	
	/// 通知時刻
	dynamic var date = Date()
}
