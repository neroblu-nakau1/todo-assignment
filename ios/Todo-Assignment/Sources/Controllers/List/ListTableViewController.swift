// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class ListTableViewController: TableViewController {
    
    typealias SelectedClosure        = (Task) -> ()
    typealias TappedCompletedClosure = (Task) -> ()
    
    var selected:        SelectedClosure?
    var tappedCompleted: TappedCompletedClosure?
    
    func setup(_ tableView: UITableView, selected: @escaping SelectedClosure, tappedCompleted: @escaping TappedCompletedClosure) {
        self.setup(tableView)
        self.selected        = selected
        self.tappedCompleted = tappedCompleted
    }
    
    func reloadData() {
        App.Model.Task.loadAll()
        self.tableView?.reloadData()
    }
    
    var taskSegment: TaskSegment = .today {
        didSet {
            self.reloadData()
        }
    }
    
    var items: [Task] {
        return App.Model.Task.entities[self.taskSegment.rawValue]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(task: task), for: indexPath) as! ListTableViewCell
        cell.task = task
        cell.tappedCompleted = self.tappedCompleted
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected?(self.items[indexPath.row])
    }
    
    private func cellIdentifier(task: Task) -> String {
        if self.isEditing {
            return "edit"
        }
        return task.isCompleted ? "completed" : "normal"
    }
}
