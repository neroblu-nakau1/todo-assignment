// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

/// メモ編集画面ビューコントローラ
class MemoEditViewController: UIViewController, UITextViewDelegate {
    
    typealias EditedClosure = (String) -> ()
    
    @IBOutlet fileprivate weak var textView:         UITextView!
    @IBOutlet fileprivate weak var placeholderLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel:    UILabel!
    @IBOutlet fileprivate weak var textViewBottom:   NSLayoutConstraint!
    
    /// 編集管理時コールバック
    var edited: EditedClosure?
    
    /// 初期値
    private(set) var initialText = ""
    
    /// サブタイトル
    private(set) var subtitleText = ""
    
    /// キーボード管理オブジェクト
    private var keyboard: KeyboardEventManager!
    
    /// インスタンスを生成する
    /// - parameter title: タイトル文字列
    /// - parameter initialText: 初期値の文字列
    /// - parameter edited: 編集管理時コールバック
    /// - returns: 新しいインスタンス
    class func create(title: String, initialText: String, edited: EditedClosure?) -> MemoEditViewController {
        let ret = App.Storyboard("MemoEdit").get(MemoEditViewController.self)
        ret.initialText  = initialText
        ret.subtitleText = title
        ret.edited       = edited
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subtitleLabel.text = self.subtitleText
        self.setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.becomeFirstResponder()
    }
    
    /// テキストビューの初期設定
    private func setupTextView() {
        self.keyboard = KeyboardEventManager() { [unowned self] distance in
            self.textViewBottom.constant = distance
        }
        self.textView.text = self.initialText
        self.textView.delegate = self
        
        self.textViewDidChange(self.textView)
    }
    
    /// 保存ボタン押下時
    @IBAction private func didTapCommitButton() {
        self.edited?(self.textView.text)
        self.dismiss()
    }
    
    /// キャンセルボタン押下時
    @IBAction private func didTapCancelButton() {
        self.dismiss()
    }
    
    /// テキストビュー値変更時
    func textViewDidChange(_ textView: UITextView) {
        self.placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
