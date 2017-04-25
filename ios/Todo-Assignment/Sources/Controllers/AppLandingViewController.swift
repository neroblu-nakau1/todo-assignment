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
                    self.present(MemoEditViewController.create(initialText: "") { text in
                        
                    })
                },
                LandingItem("通知設定") {
                    
                },
                ]
            ),
            (title:"モデル", rows:[
                LandingItem("パス") {
                    print(App.Model.Task.realmPath)
                },
                LandingItem("Fixture") {
					App.Model.Task.fixture()
				},
                LandingItem("タスク") {
                    let task = App.Model.Task.create(title: "新しいタスク")
                    App.Model.Task.save(task)
                },
                LandingItem("ローカル通知") {
                    
                },
                
                ]
            ),
            (title:"API", rows:[
				LandingItem("テスト") {
					//print(App.Model.LocalNotification.generateDeliverIdentifier())
				},
                LandingItem("テスト") {
                    let date = Date.create().added(second: 4)
                    //print(date.string)
                    App.Model.LocalNotification.manager.add(title: "テストー", date: date)
                },
                ]
            ),
        ]
    }
}
