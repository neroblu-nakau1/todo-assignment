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
                LandingItem("詳細") {
                    self.present(DetailViewController.create())
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
                LandingItem("タスク") {
                    
                },
                LandingItem("ローカル通知") {
                    
                },
                ]
            ),
            (title:"API", rows:[
                LandingItem("テスト") {
                    
                },
                ]
            ),
        ]
    }
}
