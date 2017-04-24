// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

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

protocol DetailTableViewControllerDelegate: NSObjectProtocol {
    
    func didTapDate(_ adapter: DetailTableViewController)
    
    func didTapNotify(_ adapter: DetailTableViewController)
    
    func didTapMemo(_ adapter: DetailTableViewController)
    
    func didTapRemoveNotify(_ adapter: DetailTableViewController)
    
    func didSelectPriority(_ adapter: DetailTableViewController)
    
    func didTapDelete(_ adapter: DetailTableViewController)
}

class DetailTableViewController: TableViewController {
    
    private weak var task: Task!
    
    weak var delegate: DetailTableViewControllerDelegate?
    
    func setup(_ tableView: UITableView, task: Task) {
        self.setup(tableView)
        self.task = task
        tableView.estimatedRowHeight = 64.0
        tableView.rowHeight          = UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailTableViewItem.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = DetailTableViewItem.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.rawValue, for: indexPath) as! DetailTableViewCell
        cell.task = self.task
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
