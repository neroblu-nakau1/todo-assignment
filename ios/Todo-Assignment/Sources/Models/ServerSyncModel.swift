// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - サーバ同期モデル -
class ServerSyncModel {
    
    typealias CompletedClosure = ()->()
    
    private var completed: CompletedClosure!
    private var processes = [ServerSyncProcessable]()
    private var index = 0, max = 0
    
    /// サーバ同期処理の実行
    /// - parameter completed: 処理完了のコールバック
    func synchronize(completed: @escaping CompletedClosure) {
        self.completed = completed
        
        self.processes = []
        self.processes.append(contentsOf: ServerSyncCreateProcess.processes())
        self.processes.append(contentsOf: ServerSyncUpdateProcess.processes())
        self.processes.append(contentsOf: ServerSyncDeleteProcess.processes())
        
        self.index = 0;
        self.max = self.processes.indices.last ?? -1
        
        self.processRecursive()
    }
    
    /// 再帰的に順番に処理を行う
    private func processRecursive() {
        if self.index > self.max {
            print("*** SERVER SYNC COMPLETED ***")
            self.processes = []
            self.completed()
            return
        }
        
        print("*** SERVER SYNC PROCESS (\(self.index) / \(self.max)) ***")
        
        let process = self.processes[self.index]
        process.start { [unowned self] in
            self.index += 1
            self.processRecursive()
        }
    }
}

// MARK: - App.Model拡張 -
extension App.Model {
    
    /// サーバ同期モデル
    static let ServerSync = ServerSyncModel()
}
