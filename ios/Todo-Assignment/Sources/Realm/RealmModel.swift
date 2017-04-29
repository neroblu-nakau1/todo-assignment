// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit
import RealmSwift

/// ソート方向
enum RealmSortAscending {
    case asc
    case desc
    
    var ascending: Bool { return self == .asc }
}

/// ソート情報 [フィールド名 : 昇順降順)]
typealias RealmSort = [String : RealmSortAscending]

/// 取得制限情報 (offset: オフセット位置, count: 件数)
typealias RealmLimit = (offset: Int, count: Int)

/// Realmモデルクラス
class RealmModel<T: RealmEntity> {
    
    /// モデルが扱うエンティティ
    typealias Entity = T
    
    /// データ更新クロージャ
    typealias UpdatingClosure = (Entity) -> Void
    
    /// データ更新クロージャ(複数)
    typealias MultiUpdatingClosure = (Entity, Int) -> Void
    
    /// Realmオブジェクト
    var realm: RealmSwift.Realm { return try! RealmSwift.Realm() }
    
    /// Realmファイルのパス
    static var realmPath: String {
        return RealmSwift.Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? ""
    }
    
    // MARK: - エンティティ生成
    
    /// 新しいエンティティを生成する
    /// - parameter id: エンティティに与えるID(省略時は自動的に採番)
    /// - returns: 新しいエンティティ
    func create(id: Int? = nil) -> Entity {
        let ret = Entity()
        ret.id = id ?? self.autoIncrementedID
        return ret
    }
    
    /// オートインクリメントされたID値
    var autoIncrementedID: Int {
        guard let max = self.realm.objects(Entity.self).sorted(byKeyPath: RealmEntity.idKey, ascending: false).first else {
            return 1
        }
        return max.id + 1
    }
    
    // MARK: - 共通処理
    
    /// 指定した条件・ソートから結果オブジェクトを取得する
    /// - parameter condition: 条件
    /// - parameter sort: ソート
    /// - returns: RealmResultsオブジェクト
    fileprivate func getResult(condition: NSPredicate? = nil, sort: RealmSort? = nil) -> RealmSwift.Results<Entity> {
        var result = self.realm.objects(Entity.self)
        if let condition = condition {
            result = result.filter(condition)
        }
        
        sort?.forEach {
            result = result.sorted(byKeyPath: $0.key, ascending: $0.value.ascending)
        }
        return result
    }
    
    func transact(process: ((RealmSwift.Realm) -> ())) {
        let realm = self.realm
        try! realm.write { process(realm) }
    }
    
    // MARK: - 取得 -
    
    /// 指定した条件とソートで抽出したエンティティ配列を取得する
    /// - parameter condition: 条件
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
            return result.map { $0 }
        }
    }
    
    /// 指定した複数のIDで抽出したエンティティ配列を取得する
    /// - parameter ids: IDの配列
    func select(ids: [Int], sort: RealmSort? = nil, limit: RealmLimit? = nil) -> [Entity] {
        return self.select(condition: NSPredicate(ids: ids), sort: sort, limit: limit)
    }
    
    /// 指定したIDで抽出したエンティティ取得する
    /// - parameter id: ID
    func select(id: Int) -> Entity? {
        return self.select(condition: NSPredicate(id: id)).first
    }
    
    /// 指定した条件で抽出されるエンティティ数を取得する
    /// - parameter condition: 条件オブジェクト
    /// - returns: エンティティ数
    func count(condition: NSPredicate? = nil) -> Int {
        return self.getResult(condition: condition).count
    }
    
    // MARK: - 保存
    
    /// 複数のエンティティを保存する
    /// - parameter entities: エンティティの配列
    func save(_ entities: [Entity]) {
        self.transact() { r in
            for entity in entities {
                entity.modified = Date()
            }
            r.add(entities, update: true)
        }
    }
    
    /// エンティティを保存する
    /// - parameter entity: エンティティ
    func save(_ entity: Entity) {
        self.save([entity])
    }
    
    // MARK: - 挿入(新規追加)
    
    /// エンティティ配列から一括で新規追加する
    /// - parameter entities: エンティティの配列
    func insert(_ entities: [Entity]) {
        let id = self.autoIncrementedID
        self.transact() { r in
            for (i, entity) in entities.enumerated() {
                entity.id       = id + i
                entity.created  = Date()
                entity.modified = Date()
                r.add(entity, update: true)
            }
        }
    }
    
    /// エンティティを新規追加する
    /// - parameter entity: エンティティ
    func insert(_ entity: Entity) {
        self.insert([entity])
    }
    
    // MARK: - 削除
    
    /// 指定した条件に該当するエンティティを削除する
    /// - parameter condition: 条件
    func delete(condition: NSPredicate) {
        self.transact() { r in
            r.delete(r.objects(Entity.self).filter(condition))
        }
    }
    
    /// 指定した複数のIDに該当するエンティティを削除する
    /// - parameter ids: IDの配列
    func delete(ids: [Int]) {
        self.delete(condition: NSPredicate(ids: ids))
    }
    
    /// 指定したIDのエンティティを削除する
    /// - parameter id: ID
    func delete(id: Int) {
        self.delete(condition: NSPredicate(id: id))
    }

    /// 指定した複数のエンティティを削除する
    /// - parameter entities: エンティティ
    func delete(_ entities: [Entity]) {
        self.transact() { r in
            r.delete(entities)
        }
    }
    
    /// 指定したエンティティを削除する
    /// - parameter entity: エンティティ
    func delete(_ entity: Entity) {
        self.delete([entity])
    }
    
    // MARK: - 更新
    
    /// 指定した条件に該当するエンティティを更新する
    /// - parameter condition: 条件
    /// - parameter updating: データ更新クロージャ
    func update(condition: NSPredicate? = nil, updating: MultiUpdatingClosure) {
        self.transact() { r in
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
    
    /// 指定した複数IDに該当するエンティティを更新する
    /// - parameter ids: IDの配列
    /// - parameter updating: データ更新クロージャ
    func update(ids: [Int], updating: MultiUpdatingClosure) {
        self.update(condition: NSPredicate(ids: ids), updating: updating)
    }
    
    /// 指定したIDに該当するエンティティを更新する
    /// - parameter id: ID
    /// - parameter updating: データ更新クロージャ
    func update(id: Int, updating: UpdatingClosure) {
        self.transact() { r in
            let result = r.objects(Entity.self).filter(NSPredicate(id: id))
            if let entity = result.first {
                entity.modified = Date()
                updating(entity)
            }
        }
    }
    
    /// 複数のエンティティを更新する
    /// - parameter entities: エンティティの配列
    /// - parameter updating: データ更新クロージャ
    func update(_ entities: [Entity], updating: MultiUpdatingClosure) {
        self.transact() { r in
            for (i, entity) in entities.enumerated() {
                entity.modified = Date()
                updating(entity, i)
                r.add(entity, update: true)
            }
        }
    }
    
    /// エンティティを更新する
    /// - parameter entity: エンティティ
    /// - parameter updating: データ更新クロージャ
    func update(_ entity: Entity, updating: UpdatingClosure) {
        self.transact() { r in
            entity.modified = Date()
            updating(entity)
            r.add(entity, update: true)
        }
    }
}
