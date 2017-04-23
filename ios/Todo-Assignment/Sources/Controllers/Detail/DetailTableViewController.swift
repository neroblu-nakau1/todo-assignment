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

class DetailTableViewController: TableViewController {
    
    private weak var task: Task!
    
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
}
