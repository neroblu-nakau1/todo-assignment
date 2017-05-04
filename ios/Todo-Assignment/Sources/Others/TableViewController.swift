// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// テーブルビューを管理するビューコントローラ
class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /// テーブルビュー
    weak var tableView: UITableView?
    
    /// テーブルビューのセットアップを行う
    /// - parameter tableView: テーブルビュー
    func setup(_ tableView: UITableView) {
        tableView.delegate   = self
        tableView.dataSource = self
        self.tableView = tableView
    }
    
    // 以下、UITableViewDelegate, UITableViewDataSource の実装
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
