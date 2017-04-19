// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - LandingItem -

/// LandingViewControllerの項目クラス
class LandingItem {
    
    typealias SelectedHandler = () -> ()
    
    fileprivate let title:   String
    fileprivate let handler: SelectedHandler
    
    /// イニシャライザ
    /// - parameter title: 項目タイトル
    /// - parameter handler: 項目選択時の処理
    public init(_ title: String, _ handler: @escaping SelectedHandler) {
        self.title   = title
        self.handler = handler
    }
}

// MARK: - LandingViewController -

/// ランディング画面ビューコントローラ
class LandingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let cellIdentifier = "item"
    
    /// テーブルビュー
    @IBOutlet private weak var tableView: UITableView!
    
    /// ランディング画面の項目の定義を返す
    /// - returns: title: セクションのタイトル, rows: 項目の配列
    var items: [(title: String, rows: [LandingItem])] {
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        let item = self.items[indexPath.section].rows[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.items[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.items[indexPath.section].rows[indexPath.row]
        item.handler()
    }
}
