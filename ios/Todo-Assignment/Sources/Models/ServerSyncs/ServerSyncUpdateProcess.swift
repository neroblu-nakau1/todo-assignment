// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// サーバ同期処理: 更新
class ServerSyncUpdateProcess: ServerSyncProcessable {
    
    /// 対象のタスク
    let task: Task
    
    /// コンストラクタ
    /// - parameter task: 対象のタスクエンティティ
    init(task: Task) {
        self.task = task
    }
    
    /// 処理開始
    func start(finished: @escaping FinishedClosure) {
        App.API.request(UpdateTaskRequest(task: self.task)) { _, _ in
            finished()
        }
    }
    
    /// 同期する処理の作成
    static func processes() -> [ServerSyncProcessable] {
        return App.Model.Task.fetchUnsyncedEntities(serverIdentifierIsEmpty: false, isDeleted: false).map {
            return ServerSyncUpdateProcess(task: $0)
        }
    }
}
