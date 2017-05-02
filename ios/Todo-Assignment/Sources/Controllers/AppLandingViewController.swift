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
                LandingItem("試し") {
                    App.API.request(TestRequest()) { response, result in
//                        print(result.requestedURL)
//                        print(result.error)
                        print(response)
                    }
                },
                LandingItem("Update") {
                    App.Model.Task.loadAll()
                    guard let task = App.Model.Task.entities.first?.first else { return }
                    App.API.request(UpdateTaskRequest(task: task)) { response, _ in
                        print(response)
                    }
                },
                LandingItem("Create") {
                    App.Model.Task.loadAll()
                    guard let task = App.Model.Task.entities.first?.first else { return }
                    App.API.request(CreateTaskRequest(task: task)) { response, result in
                        print("---")
                        //print(result.error, result.statusCode)
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
                LandingItem("ユーザトークン削除") {
                    print("'\(App.Model.Keychain.token)'を削除")
                    App.Model.Keychain.token = ""
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
