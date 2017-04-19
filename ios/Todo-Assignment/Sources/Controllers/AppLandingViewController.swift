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
                    
                },
                LandingItem("メモ") {
                    
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
