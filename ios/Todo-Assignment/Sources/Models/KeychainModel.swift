// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import KeychainAccess

// MARK: - キーチェーン設定モデル -
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

// MARK: - App.Model拡張 -
extension App.Model {
    
    /// キーチェーン設定モデル
    static let Keychain = KeychainModel()
}
