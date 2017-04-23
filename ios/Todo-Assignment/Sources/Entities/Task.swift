// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class Task: RealmEntity {
    
    /// タイトル(タスク名)
    dynamic var title = ""
    
    /// 期限日
    dynamic var date = Date()
    
    /// 通知時刻
    dynamic var notifyDate: Date? = nil
    
    /// 重要度
    dynamic var priority = 1
    
    /// メモ
    dynamic var memo = ""
    
    /// 完了フラグ
    dynamic var isCompleted = false
}
