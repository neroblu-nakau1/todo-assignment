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
                    let date = DateComponents(calendar: Date.calendar, minute: 5, second: 30).date!
                    print(date)
                    App.LocalNotify.add(title: "テストー", date: date)
                },
                ]
            ),
        ]
    }
}
