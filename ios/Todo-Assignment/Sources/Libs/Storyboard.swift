// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

// MARK: - App拡張 -
extension App {
    
    /// StoryboardManagerオブジェクトを作成する
    /// - parameter name: ストーリーボード名
    /// - parameter bundle: バンドル
    /// - parameter id: ストーリーボード上のID文字列
    /// - returns: StoryboardManager
    public static func Storyboard(_ name: String, bundle: Bundle? = nil, id: String? = nil) -> StoryboardManager {
        return StoryboardManager(name: name, bundle: bundle, id: id)
    }
}

// MARK: - StoryboardManager -

/// ストーリーボードの処理を行うクラス
class StoryboardManager {
    
    /// ストーリーボードIDを設定する
    /// - parameter storyboardIdentifier: ストーリーボード上のID文字列
    /// - returns: 自身の参照
    func id(_ storyboardIdentifier: String) -> StoryboardManager {
        self.storyboardIdentifier = storyboardIdentifier
        return self
    }
    
    /// ストーリーボード上のコントローラを取得する
    /// - returns: コントローラ(事前にストーリーボードIDの設定がない場合はルートビューコントローラの返却を試みる)
    func get() -> UIViewController {
        if let id = self.storyboardIdentifier {
            return self.storyboard.instantiateViewController(withIdentifier: id)
        } else {
            guard let vc = self.storyboard.instantiateInitialViewController() else {
                fatalError("not found root(initial) view controller in storyboard of '\(self.name)'")
            }
            return vc
        }
    }
    
    /// ストーリーボード上のコントローラを取得する
    /// - parameter type: 取得するビューコントローラの型
    /// - returns: コントローラ(事前にストーリーボードIDの設定がない場合はルートビューコントローラの返却を試みる)
    func get<T: UIViewController>(_ type: T.Type) -> T {
        guard let vc = self.get() as? T else {
            fatalError("view controller is not match type in storyboard of '\(self.name)'")
        }
        return vc
    }
    
    private var storyboard: UIStoryboard
    private var name: String
    private var storyboardIdentifier: String?
    
    fileprivate init(name: String, bundle: Bundle?, id: String?) {
        self.name = name
        self.storyboardIdentifier = id
        self.storyboard = UIStoryboard(name: name, bundle: bundle)
    }
}

// MARK: - UINib拡張 -
extension UINib {
    
    /// Nibファイルの存在確認を行ってからUINibオブジェクトを返す
    /// - parameter name: Nibファイル名
    /// - parameter bundle: バンドル
    /// - returns: UINibオブジェクト(存在しない場合はnil)
    class func create(nibName name: String, bundle bundleOrNil: Bundle?) -> UINib? {
        let bundle = bundleOrNil ?? Bundle.main
        if let _ = bundle.path(forResource: name, ofType: "nib") {
            return UINib(nibName: name, bundle: bundle)
        }
        return nil
    }
}

