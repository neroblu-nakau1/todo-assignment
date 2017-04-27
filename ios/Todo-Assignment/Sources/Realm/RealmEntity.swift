// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import RealmSwift

/// RealmObjectを継承したデータエンティティクラス
class RealmEntity: RealmSwift.Object {
    
    static let idKey       = "id"
    static let createdKey  = "created"
    static let modifiedKey = "modified"
    
    /// オブジェクトID
    dynamic var id = 0 // = NBRealmEntityIDKey
    
    /// 作成日時
    dynamic var created = Date() // = NBRealmEntityCreatedKey
    
    /// 更新日時
    dynamic var modified = Date() // = NBRealmEntityModifiedKey
    
    /// 主キー設定
    override static func primaryKey() -> String? {
        return RealmEntity.idKey
    }
}
