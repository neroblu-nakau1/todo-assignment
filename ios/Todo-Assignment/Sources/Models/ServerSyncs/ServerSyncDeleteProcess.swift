// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// サーバ同期処理: 削除
class ServerSyncDeleteProcess: ServerSyncProcessable {
    
    /// 削除対象のサーバ識別子の配列
    let serverIdentifiers: [String]
    
    /// コンストラクタ
    /// - parameter serverIdentifiers: 削除対象のサーバ識別子の配列
    init(serverIdentifiers: [String]) {
        self.serverIdentifiers = serverIdentifiers
    }
    
    /// 処理開始
    func start(finished: @escaping FinishedClosure) {
        if self.serverIdentifiers.isEmpty {
            print("- No Delete")
            finished()
            return
        }
        App.API.request(DeleteTaskRequest(serverIdentifiers: self.serverIdentifiers)) { _, result in
            if result.ok {
                App.Model.Task.drop(serverIdentifiers: self.serverIdentifiers)
            }
            finished()
        }
    }
    
    /// 同期する処理の作成
    static func processes() -> [ServerSyncProcessable] {
        return [ServerSyncDeleteProcess(serverIdentifiers: App.Model.Task.fetchUnsyncedEntities(serverIdentifierIsEmpty: false, isDeleted: true).map {
            return $0.serverIdentifier
        })]
    }
}
