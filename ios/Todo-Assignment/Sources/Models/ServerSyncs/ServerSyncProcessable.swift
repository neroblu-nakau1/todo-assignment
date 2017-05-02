// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// サーバとの同期処理を行うプロトコル
protocol ServerSyncProcessable {
    
    typealias FinishedClosure = () -> ()
    
    /// 処理を開始する
    /// - parameter finished: 処理が終了した時のコールバック
    func start(finished: @escaping FinishedClosure)
    
    /// 同期する処理の作成
    /// - returns: 同期する処理の配列
    static func processes() -> [ServerSyncProcessable]
}
