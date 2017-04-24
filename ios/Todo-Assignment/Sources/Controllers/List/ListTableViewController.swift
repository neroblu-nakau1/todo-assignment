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
    
    var selectedIds = [Int64]()
    
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
        
        if self.isEditing {
            cell.isChecked = self.isEditSelected(id: task.id)
        }
        
        return cell
    }
    
    private func toggleSelectedId(_ id: Int64) {
        if let index = self.selectedIds.index(of: id) {
            self.selectedIds.remove(at: index)
        } else {
            self.selectedIds.append(id)
        }
        self.tableView?.reloadData()
    }
    
    private func isEditSelected(id: Int64) -> Bool {
        return self.selectedIds.index(of: id) != nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.items[indexPath.row]
        if self.isEditing {
            self.toggleSelectedId(task.id)
        } else {
            self.selected?(task)
        }
    }
    
    func toggleAllSelected() {
        var fill = false
        for task in self.items {
            guard let _ = self.selectedIds.index(of: task.id) else {
                fill = true
                break
            }
        }
        self.selectedIds.removeAll()
        if fill {
            for task in self.items {
                self.selectedIds.append(task.id)
            }
        }
        self.tableView?.reloadData()
    }
    
    override var isEditing: Bool {
        didSet { let v = self.isEditing
            self.tableView?.reloadData()
            if (!v) {
                self.selectedIds = []
            }
        }
    }
    
    private func cellIdentifier(task: Task) -> String {
        if self.isEditing {
            return "edit"
        }
        return task.isCompleted ? "completed" : "normal"
    }
}
