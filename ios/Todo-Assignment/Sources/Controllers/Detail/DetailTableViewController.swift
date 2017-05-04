// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - DetailTableViewItem -

/// テーブルビュー項目
enum DetailTableViewItem: String {
    case date
    case notify
    case priority
    case memo
    case delete
    
    static var items: [DetailTableViewItem] {
        return [.date, .notify, .priority, .memo, .delete]
    }
}

// MARK: - DetailTableViewAdapterDelegate -

/// DetailTableViewAdapterのデリゲートプロトコル
protocol DetailTableViewAdapterDelegate: NSObjectProtocol {

    /// 日付が押下された時
    /// - parameter adapter: 送り元のアダプタ
    func didTapDate(_ adapter: DetailTableViewAdapter)

    /// 通知が押下された時
    /// - parameter adapter: 送り元のアダプタ
    func didTapNotify(_ adapter: DetailTableViewAdapter)
    
    /// メモが押下された時
    /// - parameter adapter: 送り元のアダプタ
    func didTapMemo(_ adapter: DetailTableViewAdapter)
    
    /// 通知削除が押下された時
    /// - parameter adapter: 送り元のアダプタ
    func didTapRemoveNotify(_ adapter: DetailTableViewAdapter)
    
    /// 重要度の値が選択された時
    /// - parameter adapter: 送り元のアダプタ
    /// - parameter priority: 選択された重要度の値
    func didSelectPriority(_ adapter: DetailTableViewAdapter, selectPriority priority: Int)
    
    /// 削除が押下された時
    /// - parameter adapter: 送り元のアダプタ
    func didTapDelete(_ adapter: DetailTableViewAdapter)
}

// MARK: - DetailTableViewAdapter -

/// 詳細画面用テーブルビューアダプタ
class DetailTableViewAdapter: TableViewAdapter {
    
    /// タスク
    private weak var task: Task!
    
    /// デリゲート
    weak var delegate: DetailTableViewAdapterDelegate?
    
    /// テーブルビューのセットアップ
    /// - parameter tableView: テーブルビュー
    /// - parameter task: タスク
    func setup(_ tableView: UITableView, task: Task) {
        self.setup(tableView)
        self.task = task
        tableView.estimatedRowHeight = 64.0
        tableView.rowHeight          = UITableViewAutomaticDimension
    }
    
    /// データのリロード
    func reloadData() {
        self.tableView?.reloadData()
    }
    
    /// 通知セルのセットアップ
    /// - parameter cell: セル
    private func setup(notify cell: UITableViewCell) {
        if let notify = cell as? DetailTableViewNotifyCell {
            notify.tappedRemove = { [unowned self] in
                self.delegate?.didTapRemoveNotify(self)
            }
        }
    }

    /// 重要度セルのセットアップ
    /// - parameter cell: セル
    private func setup(priority cell: UITableViewCell) {
        if let priority = cell as? DetailTableViewPriorityCell {
            priority.priorityChanged = { [unowned self] value in
                self.delegate?.didSelectPriority(self, selectPriority: value)
            }
        }
    }
    
    /// 削除セルのセットアップ
    /// - parameter cell: セル
    private func setup(delete cell: UITableViewCell) {
        if let delete = cell as? DetailTableViewDeleteCell {
            delete.tappedDelete = { [unowned self] in
                self.delegate?.didTapDelete(self)
            }
        }
    }
    
    // MARK: - tableview delegates
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailTableViewItem.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = DetailTableViewItem.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.rawValue, for: indexPath) as! DetailTableViewCell
        cell.task = self.task
        
        self.setup(notify: cell)
        self.setup(priority: cell)
        self.setup(delete: cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = DetailTableViewItem.items[indexPath.row]
        switch item {
        case .date:   self.delegate?.didTapDate(self)
        case .notify: self.delegate?.didTapNotify(self)
        case .memo:   self.delegate?.didTapMemo(self)
        default:break
        }
    }
}
