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
            (title:"モデル", rows:[
                LandingItem("パス") {
                    print(RealmModel.realmPath)
                },
                LandingItem("Fixture") {
					App.Model.Task.fixture()
				},
                LandingItem("ユーザトークン削除") {
                    print("'\(App.Model.Keychain.token)'を削除")
                    App.Model.Keychain.token = ""
                },
                LandingItem("正しいサーバ") {
                    App.API = ApiAccessor(baseURL: "https://\(App.NgrokDomain)/")
                },
                LandingItem("間違えたサーバ") {
                    App.API = ApiAccessor(baseURL: "https://wrong.wrong.wrong/")
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
