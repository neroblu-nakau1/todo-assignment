// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

enum TaskSegment: Int {
    case today
    case incomplete
    case completed
    
    static let count = 3
    
//    var predicate: NSPredicate {
//        switch self {
//        case .today:
//            NSPredicate.empty
//            .and(NSPredicate("isCompleted", equal: false).and(<#T##predicate: NSPredicate##NSPredicate#>))
//            .and(NSPredicate("date", fromDate: <#T##Date?#>, toDate: <#T##Date?#>))
//        case .incomplete:
//            
//        case .completed:
//        }
//    }
}

class TaskModel: RealmModel<Task> {
    
    fileprivate(set) var entities = [
        [Entity](), // today
        [Entity](), // incomplete
        [Entity](), // completed
    ]
    
    /// すべてを読み込む
    func loadAll() {
//        let entities = self.select()
//        for entity in entities {
//            self.loadListImage(entity)
//        }
//        self.entities = entities
    }
    
    /// すべてクリアする
    func clearAll() {
        self.entities = []
    }
    
    /// 新しいエンティティを生成する
    /// - parameter title: タイトル(タスク名)
    /// - parameter withID: エンティティに与えるID(省略時は自動的に採番)
    /// - returns: 新しいエンティティ
    func create(title: String, withID id: Int64? = nil) -> Entity {
        let ret = self.create(withID: id)
        ret.title = title
        ret.date  = Date.today()
        return ret
    }
    
    override func clone(_ entity: Entity) -> Entity {
        let ret = super.clone(entity)
        ret.title       = entity.title
        ret.priority    = entity.priority
        ret.date        = entity.date
        ret.notifyDate  = entity.notifyDate
        ret.memo        = entity.memo
        ret.isCompleted = entity.isCompleted
        return ret
    }
}

// MARK: - App.Model拡張 -
extension App.Model {
    
    /// タスクモデル
    static let Task = TaskModel()
}






/*
/// 選手モデル
class PlayerModel: NBRealmAccessor<Player> {
    
    /// チーム名の最大文字数
    static let NameMaxLength = 40
    
    // MARK: 選手一覧用
    
    fileprivate(set) var entities = [Entity]()
    
    /// チームのすべての選手を読み込む
    func loadAll() {
        let entities = self.select()
        for entity in entities {
            self.loadListImage(entity)
        }
        self.entities = entities
    }
    
    /// チームのすべての選手を読み込む
    /// - parameter team: チームエンティティ
    func loadAll(team: Team) {
        let entities = self.select()
        for entity in entities {
            self.loadListImage(entity)
        }
        self.entities = entities
    }
    
    /// 読み込んだ選手をクリアする
    func clearAll() {
        self.entities = []
    }
    
    // MARK: 選手編集用
    
    /// 指定したIDの選手を返す
    /// - parameter id: ID
    /// - returns: 選手エンティティ(存在しない場合はnil)
    func load(id: Int64) -> Entity? {
        let entities = self.select(condition: NSPredicate(id: id))
        return entities.last
    }
    
    // MARK: バリデーション
    
    /// 渡したエンティティのバリデーションを行う
    /// - parameter entity: 選手エンティティ
    /// - returns: バリデートエラーが有る場合のみメッセージ文字列
    func validate(_ entity: Entity) -> String? {
        if entity.name.isEmpty {
            return "player name is required".localize()
        }
        return nil
    }
    
    // MARK: 画像
    
    /// 指定した選手の一覧用画像をローカルの保存場所から読み込んでセットする
    /// - parameter entity: 選手エンティティ
    func loadListImage(_ entity: Entity) {
        entity.thumbImage = ImageFileUtil.loadImage(.PlayerThumbImage, identifier: entity.id)
    }
    
    /// 指定した選手の編集用画像をローカルの保存場所から読み込んでセットする
    /// - parameter entity: 選手エンティティ
    func loadEditImage(_ entity: Entity) {
        entity.faceImage       = ImageFileUtil.loadImage(.PlayerFaceImage, identifier: entity.id)
        entity.thumbImage      = ImageFileUtil.loadImage(.PlayerThumbImage, identifier: entity.id)
        entity.playerImage     = ImageFileUtil.loadImage(.PlayerImage,     identifier: entity.id)
        entity.playerHalfImage = ImageFileUtil.loadImage(.PlayerHalfImage, identifier: entity.id)
    }
    
    /// 指定した選手の画像をローカルの保存場所に保存する
    /// - parameter entity: 選手エンティティ
    /// - parameter emblemThumb: エンブレムサムネイル用画像
    /// - parameter teamThumb: チームサムネイル用画像
    func saveImage(_ entity: Entity) {
        ImageFileUtil.saveImage(.PlayerFaceImage,  identifier: entity.id, image: entity.faceImage)
        ImageFileUtil.saveImage(.PlayerThumbImage, identifier: entity.id, image: entity.thumbImage)
        ImageFileUtil.saveImage(.PlayerImage,      identifier: entity.id, image: entity.playerImage)
        ImageFileUtil.saveImage(.PlayerHalfImage,  identifier: entity.id, image: entity.playerHalfImage)
    }
    
    /// 指定した選手の画像をクリアする
    /// - parameter entity: 選手エンティティ
    func clearImage(_ entity: Entity) {
        entity.playerHalfImage = nil
        entity.playerImage     = nil
        entity.faceImage       = nil
    }
    
    // MARK: 入力値の加工
    
    /// 選手名(国際名)入力値の加工を行う
    /// - parameter raw: 入力された文字列
    /// - returns: 加工された文字列
    func processInternationalName(_ raw: String) -> String {
        var ret = raw // cast to mutable
        
        let maxLen = PlayerModel.NameMaxLength
        if ret.length > maxLen {
            ret = ret.ns.substring(to: maxLen)
        }
        ret = join(ret.matchedStrings("[a-zA-Z0-9\\. ]"), "")
        
        return ret
    }
    
    // MARK: 入力値の制限
    
    /// チーム名(国際名)入力では使用できない文字列かどうかを返す
    /// - parameter text: 対象の文字列
    /// - returns: 使用できない文字列かどうか
    func isRestrictedTextOfInternationalName(_ text: String) -> Bool {
        return !text.isEmpty && !text.isMatched("^[a-zA-Z0-9\\. ]+$")
    }
    
    override func clone(_ entity: Entity) -> Entity {
        let ret = super.clone(entity)
        ret.name              = entity.name
        ret.familyName        = entity.familyName
        ret.internationalName = entity.internationalName
        ret.shortenedName     = entity.shortenedName
        ret.uniformNumber     = entity.uniformNumber
        ret.position          = entity.position
        ret.faceImage         = entity.faceImage
        ret.thumbImage        = entity.thumbImage
        ret.playerImage       = entity.playerImage
        ret.playerHalfImage   = entity.playerHalfImage
        
        return ret
    }
}

// MARK: - App.Model拡張 -
extension App.Model {
    
    /// 選手モデル
    static let Player = PlayerModel()
}

// MARK: - App.Model拡張 -
extension App.Dimen {
    
    /// 選手
    struct Player {
        /// 顔画像の幅
        static let FaceImageWidth: CGFloat = 280
        /// 顔サムネイル画像の幅
        static let FaceThumbImageWidth: CGFloat = 150
    }
}

// MARK: - ImageUtil拡張 -
extension ImageUtil {
    
    class func playerFaceImage(_ src: UIImage?) -> UIImage? {
        let width = App.Dimen.Player.FaceImageWidth, size = cs(width, width)
        return self.adjustedImage(src, size: size)
    }
    
    class func playerThumbImage(_ src: UIImage?) -> UIImage? {
        let width = App.Dimen.Player.FaceThumbImageWidth, size = cs(width, width)
        return self.adjustedImage(src, size: size)
    }
    
    class func playerImage(_ src: UIImage?) -> UIImage? {
        guard let image = src else { return nil }
        
        let w = App.Dimen.Screen.RetinaSize.width
        let h = (image.size.height / image.size.width) * w
        return self.scaledImage(image, size: cs(w, h))
    }
    
    class func playerHalfImage(_ src: UIImage?) -> UIImage? {
        guard let image = self.playerImage(src) else {
            return nil
        }
        return self.croppedImage(image, rect: cr(0, 0, image.size.width, image.size.width / 2))
    }
}


// MARK: - ImageUtil拡張 -
extension PlayerModel {
    
    func sample() {
        /*
         let filePath = NSBundle.mainBundle().pathForResource("SamplePlayers.plist", ofType: nil)
         let arr = NSArray(contentsOfFile: filePath!)!
         var id = self.increasedID() - 1
         
         for (i, dic) in arr.enumerate() {
         func val<T>(v: AnyObject?, _ a: T) -> T {
         if let ret = v as? T { return ret } else { return a }
         }
         
         let ret = self.createWithType(Player.self, previousID: id)
         ret.name              = val(dic["name"], "")
         ret.familyName        = val(dic["familyName"], "")
         ret.internationalName = val(dic["internationalName"], "")
         ret.shortenedName     = val(dic["shortenedName"], "")
         ret.uniformNumber     = val(dic["uniformNumber"], "")
         ret.position          = val(dic["position"], 1)
         
         let n = ret.uniformNumber
         
         let image1 = UIImage(named: "player-sample\(n)-1.jpg")
         let image2 = UIImage(named: "player-sample\(n)-2.jpg")
         
         ret.faceImage = ImageUtil.playerFaceImage(image1)
         ret.thumbImage = ImageUtil.playerThumbImage(image1)
         ret.playerImage = ImageUtil.playerImage(image2)
         ret.playerHalfImage = ImageUtil.playerHalfImage(image2)
         
         self.save(ret)
         self.saveImage(ret)
         
         id += 1
         }
         */
    }
}
*/

extension TaskModel {
    
    func fixture() {
        let titles = [
            "f", "f", "f", "f", "f", "f", "f", "f", "f", "f", "f", "f",
        ]
        var id = self.autoIncrementedID
        
        for title in titles {
            let task = self.create(title: title, withID: id)
            
            
//            dynamic var title = ""
//            dynamic var date = Date()
//            dynamic var notifyDate: Date? = nil
//            dynamic var priority = 1
//            dynamic var memo = ""
//            dynamic var isCompleted = false
            
            
            id += 1
        }
    }
}

