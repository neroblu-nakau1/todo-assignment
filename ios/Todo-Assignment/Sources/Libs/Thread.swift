// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// メインスレッド(キュー)との同期をとって処理を実行する
/// - parameter block: メインスレッドで行う処理
func onMainThread(_ block: @escaping () -> ()) {
    DispatchQueue.main.async(execute: block)
}

/// 新しいスレッド(キュー)との同期をとって処理を実行する
/// - parameter block: 新しいスレッドで行う処理
func onNewThread(_ block: @escaping () -> ()) {
    DispatchQueue.global(qos: .default).async(execute: block)
}

/// 非同期処理を行う
/// - parameter async: 非同期処理(別スレッドで実行する処理)
/// - parameter completed: 非同期処理完了時に行う処理
func async(async asynchronousProcess: @escaping () -> (), completed completionHandler: @escaping () -> ()) {
    onNewThread {
        asynchronousProcess()
        onMainThread {
            completionHandler()
        }
    }
}
