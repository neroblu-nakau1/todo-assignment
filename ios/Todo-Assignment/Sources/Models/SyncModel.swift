// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

protocol SyncProcessable {
    
    typealias NextClosure = ()->()
    
    func start(next: @escaping NextClosure)
}

class SyncCreateProcess: SyncProcessable {
    
    let task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    func start(next: @escaping NextClosure) {
        App.API.request(CreateTaskRequest(task: self.task)) { _, _ in
            next()
        }
    }
}

class SyncUpdateProcess: SyncProcessable {
    
    let task: Task
    
    init(task: Task) {
        self.task = task
    }
    
    func start(next: @escaping NextClosure) {
        App.API.request(UpdateTaskRequest(task: self.task)) { _, _ in
            next()
        }
    }
}

class SyncDeleteProcess: SyncProcessable {
    
    let serverIdentifiers: [String]
    
    init(serverIdentifiers: [String]) {
        self.serverIdentifiers = serverIdentifiers
    }
    
    func start(next: @escaping NextClosure) {
        if self.serverIdentifiers.isEmpty {
            next()
            return
        }
        App.API.request(DeleteTaskRequest(serverIdentifiers: self.serverIdentifiers)) { _, _ in
            next()
        }
    }
}

/// サーバ同期モデル
class SyncModel {
    
    typealias CompletedClosure = ()->()
    
    private var completed: CompletedClosure!
    private var processes = [SyncProcessable]()
    private var index = 0, max = 0
    
    func synchronize(completed: @escaping CompletedClosure) {
        self.completed = completed
        self.bundleProcesses()
        
        self.index = 0;
        self.max = self.processes.indices.last ?? -1
        
        self.process()
    }
    
    func process() {
        if self.index > self.max {
            self.processes = []
            self.completed()
            return
        }
        
        let process = self.processes[self.index]
        process.start { [unowned self] in
            self.index += 1
            self.process()
        }
    }
    
    private func bundleProcesses() {
        self.processes = []
        
        // 追加すべきタスク
        self.processes.append(contentsOf: App.Model.Task.fetchUnsyncedInsertEntities().map {
            return SyncCreateProcess(task: $0)
        })
        
        // 更新すべきタスク
        self.processes.append(contentsOf: App.Model.Task.fetchUnsyncedUpdateEntities().map {
            return SyncUpdateProcess(task: $0)
        })
        
        // 削除すべきタスク
        self.processes.append(SyncDeleteProcess(serverIdentifiers: App.Model.Task.fetchUnsyncedDeleteEntities().map {
            return $0.serverIdentifier
        }))
    }
}

extension App.Model {
    
    /// サーバ同期モデル
    static let Sync = SyncModel()
}
