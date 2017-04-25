// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import RealmSwift

/// ソート情報 [(フィールド名) : (昇順: true、降順: false)]
typealias RealmSort = [String : Bool]

/// 取得制限情報
/// offset: オフセット位置
/// count: 件数
typealias RealmLimit = (offset: Int, count: Int)

/// Realmモデルクラス
class RealmModel<T: RealmEntity> {
    
    typealias Entity = T
    
    /// Realmオブジェクト
    var realm: RealmSwift.Realm { return try! RealmSwift.Realm() }
    
    /// Realmファイルのパス
    static var realmPath: String {
        return RealmSwift.Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? ""
    }
	
	// MARK: - エンティティ生成
	
    /// 新しいエンティティを生成する
    /// - parameter withID: エンティティに与えるID(省略時は自動的に採番)
    /// - returns: 新しいエンティティ
    func create(withID id: Int64? = nil) -> Entity {
        let ret = Entity()
        ret.id = id ?? self.autoIncrementedID
        return ret
    }
	
    /// オートインクリメントされたID値
    var autoIncrementedID: Int64 {
        guard let max = self.realm.objects(Entity.self).sorted(byProperty: RealmEntity.idKey, ascending: false).first else {
            return 1
        }
        return max.id + 1
    }
	
	// MARK: - レコード保存
	
    /// 指定したエンティティのレコードを更新する
    /// - parameter condition: 条件オブジェクト
    /// - parameter updating: データ更新クロージャ
    func save(_ entity: Entity) {
        self.save([entity])
    }
    
    /// 指定したエンティティのレコードを更新する
    /// - parameter condition: 条件オブジェクト
    /// - parameter updating: データ更新クロージャ
    func save(_ entities: [Entity]) {
        let r = self.realm
        try! r.write {
            for entity in entities {
                entity.modified = Date()
            }
            r.add(entities, update: true)
        }
    }
	
	// MARK: - レコード取得 -
    
    /// 指定した条件とソートでレコードを抽出しエンティティの配列で取得する
    /// - parameter condition: 条件オブジェクト
    /// - parameter sort: ソート
    /// - parameter limit: 取得制限
    /// - returns: エンティティの配列
    func select(condition: NSPredicate? = nil, sort: RealmSort? = nil, limit: RealmLimit? = nil) -> [Entity] {
        let result = self.getResult(condition: condition, sort: sort)
        if let limit = limit {
            var ret = [Entity]()
            for i in limit.offset...(limit.offset + limit.count) {
                ret.append(result[i])
            }
            return ret
        } else {
            return result.map {$0}
        }
    }
    
    /// 指定した条件で抽出されるレコード数を取得する
    /// - parameter condition: 条件オブジェクト
    /// - returns: レコード数
    func count(condition: NSPredicate? = nil) -> Int {
        return self.getResult(condition: condition, sort: nil).count
    }
    
    /// 指定した条件・ソートから結果オブジェクトを取得する
    /// - parameter condition: 条件オブジェクト
    /// - parameter sort: ソート
    /// - returns: RealmResultsオブジェクト
    fileprivate func getResult(condition: NSPredicate? = nil, sort: RealmSort? = nil) -> RealmSwift.Results<Entity> {
        var result = self.realm.objects(Entity.self)
        if let condition = condition {
            result = result.filter(condition)
        }
        if let sort = sort {
            sort.forEach {
                result = result.sorted(byProperty: $0.key, ascending: $0.value)
            }
        }
        return result
    }
	
	// MARK: - レコード追加
    
    /// エンティティの配列からレコードを一括で新規追加する
    /// - parameter entities: 追加するエンティティの配列
    func insert(_ entities: [Entity]) {
        let r = self.realm
        var i: Int64 = 0, id: Int64 = 1
        try! r.write {
            for entity in entities {
                if i == 0 { id = entity.id }
                entity.id       = id + i
                entity.created  = Date()
                entity.modified = Date()
                r.add(entity, update: true)
                i += 1
            }
        }
    }
    
    /// エンティティからレコードを新規追加する
    /// - parameter entity: 追加するエンティティ
    func insert(_ entity: Entity) {
        self.insert([entity])
    }

	// MARK: - レコード削除
    
    /// 指定した条件に該当するレコードを削除する
    /// - parameter condition: 条件オブジェクト
    func delete(_ condition: NSPredicate) {
        let r = self.realm
        try! r.write {
            r.delete(r.objects(Entity.self).filter(condition))
        }
    }
    
    /// 指定した複数のIDで抽出されるレコードを削除する
    /// - parameter ids: IDの配列
    func delete(ids: [Int64]) {
        self.delete(NSPredicate(ids: ids))
    }
    
    /// 指定したIDのレコードを削除する
    /// - parameter id: ID
    func delete(id: Int64) {
        self.delete(NSPredicate(id: id))
    }
    
    /// 指定したエンティティのレコードを削除する
    /// - parameter entity: エンティティ
    func delete(entity: Entity) {
        let r = self.realm
        try! r.write {
            r.delete(entity)
        }
    }

	// MARK: - レコード更新
    
    /// データ更新クロージャ
    /// (Entity: 更新対象のエンティティ, Int: インデックス)
    typealias RealmUpdatingClosure = (Entity, Int) -> Void
    
    /// 指定した条件で抽出されるレコードを更新する
    /// - parameter condition: 条件オブジェクト
    /// - parameter updating: データ更新クロージャ
    func update(condition: NSPredicate? = nil, updating: RealmUpdatingClosure) {
        let r = self.realm
        try! r.write {
            var result = r.objects(Entity.self)
            if let condition = condition {
                result = result.filter(condition)
            }
            var i = 0
            for entity in result {
                entity.modified = Date()
                updating(entity, i)
                i += 1
            }
        }
    }
    
    /// 指定した複数のIDで抽出されるレコードを更新する
    /// - parameter ids: IDの配列
    /// - parameter updating: データ更新クロージャ
    func update(_ ids: [Int64], updating: RealmUpdatingClosure) {
        self.update(condition: NSPredicate(ids: ids), updating: updating)
    }
    
    /// 指定したIDのレコードを更新する
    /// - parameter id: ID
    /// - parameter updating: データ更新クロージャ
    func update(_ id: Int64, updating: RealmUpdatingClosure) {
        self.update(condition: NSPredicate(id: id), updating: updating)
    }
    
    /// 指定したエンティティのレコードを更新する
    /// - parameter condition: 条件オブジェクト
    /// - parameter updating: データ更新クロージャ
    func update(_ entity: Entity, updating: RealmUpdatingClosure) {
        let r = self.realm
        try! r.write {
            entity.modified = Date()
            updating(entity, 0)
            r.add(entity, update: true)
        }
    }
}
