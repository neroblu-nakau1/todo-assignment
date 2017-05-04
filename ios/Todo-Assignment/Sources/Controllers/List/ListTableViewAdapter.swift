// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// 一覧画面用テーブルビューアダプタ
class ListTableViewAdapter: NSObject, TableViewAdaptable {
    
    typealias SelectedClosure        = (Task) -> ()
    typealias TappedCompletedClosure = (Task) -> ()
    
    var selected:        SelectedClosure?
    var tappedCompleted: TappedCompletedClosure?
    
    /// テーブルビュー
    weak var tableView: UITableView?
    
    /// 編集モードで選択されているタスクのID配列
    private(set) var selectedIds = [Int]()
    
    /// セグメントコントロールのアイテム
    var taskSegment: TaskSegment = .today {
        didSet {
            self.reloadData()
        }
    }
    
    /// 編集モードかどうか
    var isEditing: Bool = false {
        didSet { let v = self.isEditing
            self.tableView?.reloadData()
            if (!v) {
                self.selectedIds = []
            }
        }
    }
    
    /// セットアップ
    /// - parameter tableView: テーブルビュー
    /// - parameter selected: セルが選択された時のコールバック
    /// - parameter tappedCompleted: 完了ボタンが押された時のコールバック
    func setup(_ tableView: UITableView, selected: @escaping SelectedClosure, tappedCompleted: @escaping TappedCompletedClosure) {
        self.setup(tableView)
        self.selected        = selected
        self.tappedCompleted = tappedCompleted
    }
    
    /// データのリロード
    func reloadData() {
        App.Model.Task.loadAll()
        self.tableView?.reloadData()
    }
    
    /// (編集モード時)選択状態をすべて切り替える
    func toggleAllSelected() {
        var fill = false
        for task in self.tasks {
            guard let _ = self.selectedIds.index(of: task.id) else {
                fill = true
                break
            }
        }
        self.selectedIds.removeAll()
        if fill {
            for task in self.tasks {
                self.selectedIds.append(task.id)
            }
        }
        self.tableView?.reloadData()
    }
    
    /// (編集モード時)選択されているすべてのタスクを解除する
    func clearSelectedItems() {
        self.selectedIds = []
        self.reloadData()
    }
    
    /// (編集モード時)指定したタスクIDの選択状態を切り替える
    /// - parameter id: タスクID
    private func toggleSelectedId(_ id: Int) {
        if let index = self.selectedIds.index(of: id) {
            self.selectedIds.remove(at: index)
        } else {
            self.selectedIds.append(id)
        }
        self.tableView?.reloadData()
    }
    
    /// (編集モード時)指定したタスクIDのタスクが現在選択中かどうか
    /// - parameter id: タスクID
    /// - returns: 選択中かどうか
    private func isEditSelected(id: Int) -> Bool {
        return self.selectedIds.index(of: id) != nil
    }
    
    /// タスクの配列
    private var tasks: [Task] {
        return App.Model.Task.entities[self.taskSegment.rawValue]
    }
    
    /// セルのIDを取得
    /// - parameter task: タスク
    /// - returns: セルID
    private func cellIdentifier(task: Task) -> String {
        if self.isEditing {
            return "edit"
        }
        return task.isCompleted ? "completed" : "normal"
    }
    
    // MARK: - tableview delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = self.tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(task: task), for: indexPath) as! ListTableViewCell
        cell.task = task
        cell.tappedCompleted = self.tappedCompleted
        
        if self.isEditing {
            cell.isChecked = self.isEditSelected(id: task.id)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.tasks[indexPath.row]
        if self.isEditing {
            self.toggleSelectedId(task.id)
        } else {
            self.selected?(task)
        }
    }
}
