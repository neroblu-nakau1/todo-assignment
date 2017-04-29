// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import KeychainAccess

/// キーチェーン設定モデル
class KeychainModel {
    
    private let tokenKey = "com.neroblu.ios.todo-assignment.token"
    
    /// ユーザトークン
    var token: String {
        get {
            return Keychain()[self.tokenKey] ?? ""
        }
        set(v) {
            Keychain()[self.tokenKey] = v
        }
    }
}

extension App.Model {
    
    /// キーチェーン設定モデル
    static let Keychain = KeychainModel()
}
