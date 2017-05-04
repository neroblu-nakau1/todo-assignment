// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - TableViewAdaptable -

/// テーブルビューを操作するアダプタとして振る舞うプロトコル
protocol TableViewAdaptable: NSObjectProtocol, UITableViewDelegate, UITableViewDataSource {
    
    /// テーブルビュー
    weak var tableView: UITableView? { get set }
}

extension TableViewAdaptable {
    
    /// テーブルビューのセットアップを行う
    /// - parameter tableView: テーブルビュー
    func setup(_ tableView: UITableView) {
        tableView.delegate   = self
        tableView.dataSource = self
        self.tableView = tableView
    }
    
    /// データのリロードを行う
    func reloadData() {
        self.tableView?.reloadData()
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
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
