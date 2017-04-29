// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class AppLandingViewController: LandingViewController {
    
    override var items: [(title: String, rows: [LandingItem])] {
        return [
            (title:"画面", rows:[
                LandingItem("一覧") {
                    self.present(ListViewController.create())
                },
                LandingItem("メモ") {
                    self.present(MemoEditViewController.create(title: "タイトル", initialText: "") { text in
                        print(text)
                    })
                },
                ]
            ),
            (title:"APIテスト", rows:[
                LandingItem("よみ") {
                    print(App.Model.Keychain.token)
                },
                LandingItem("かき") {
                    App.Model.Keychain.token = String.randomString(length: 10)
                },
                LandingItem("試し") {
                    App.API.request(TestRequest(zipcode: "qaaa")) { response, result in
//                        print(result.requestedURL)
//                        print(result.error)
                        print(response)
                    }
                },
                ]
            ),
            (title:"モデル", rows:[
                LandingItem("パス") {
                    print(RealmModel.realmPath)
                },
                LandingItem("Fixture") {
					App.Model.Task.fixture()
				},
                ]
            ),
            (title:"ローカル通知", rows:[
				LandingItem("通知済一覧") {
					App.Model.LocalNotification.manager.printDelivered()
				},
				LandingItem("登録一覧") {
					App.Model.LocalNotification.manager.printPendigns()
				},
//				LandingItem("登録全削除") {
//					App.Model.LocalNotification.manager.removeAll()
//				},
//				LandingItem("テスト") {
//					App.Model.LocalNotification.manager.add(title: "テスト", date: Date().added(second: 3), deliverIdentifier: self.id())
////					for i in 11...84 {
////						let date = Date.create().added(second: i)
////						App.Model.LocalNotification.manager.add(title: "テスト\(i)秒", date: date, deliverIdentifier: self.id())
////					}
//				},
				]
			),
        ]
    }
	
	private func id() -> String {
		let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		let upperBound = UInt32(chars.characters.count)
		return String((0..<32).map { _ -> Character in
			return chars[chars.index(chars.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
		})
	}
}
