// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// サーバ同期処理: 追加
class ServerSyncCreateProcess: ServerSyncProcessable {
    
    /// 対象のタスク
    let task: Task
    
    /// コンストラクタ
    /// - parameter task: 対象のタスクエンティティ
    init(task: Task) {
        self.task = task
    }
    
    /// 処理開始
    func start(finished: @escaping FinishedClosure) {
        App.API.request(CreateTaskRequest(task: self.task)) { _, _ in
            finished()
        }
    }
    
    /// 同期する処理の作成
    static func processes() -> [ServerSyncProcessable] {
        return App.Model.Task.fetchUnsyncedEntities(serverIdentifierIsEmpty: true, isDeleted: false).map {
            return ServerSyncCreateProcess(task: $0)
        }
    }
}
