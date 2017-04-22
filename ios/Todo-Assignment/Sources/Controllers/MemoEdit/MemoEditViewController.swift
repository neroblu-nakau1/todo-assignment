// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class MemoEditViewController: UIViewController {
    
    typealias EditedClosure = (String) -> ()
    
    @IBOutlet fileprivate weak var textView: UITextView!
    @IBOutlet fileprivate weak var textViewBottom: NSLayoutConstraint!
    @IBOutlet fileprivate weak var placeholderLabel: UILabel!
    
    /// 編集管理時コールバック
    var edited: EditedClosure?
    
    /// 初期値
    private(set) var initialText = ""
    
    /// キーボード管理オブジェクト
    private var keyboard: KeyboardEventManager!
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create(initialText: String, edited: EditedClosure?) -> MemoEditViewController {
        let ret = App.Storyboard("MemoEdit").get(MemoEditViewController.self)
        ret.initialText = initialText
        ret.edited      = edited
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.textView.becomeFirstResponder()
    }
    
    private func setupTextView() {
        self.keyboard = KeyboardEventManager() { [unowned self] distance in
            self.textViewBottom.constant = distance
        }
        self.textView.text = self.initialText
        self.textView.selectedRange = NSMakeRange(0, 0)
        self.textView.delegate = self
    }
    
    @IBAction private func didTapCommitButton() {
        self.edited?(self.textView.text)
        self.dismiss()
    }
    
    @IBAction private func didTapCancelButton() {
        self.dismiss()
    }
}

extension MemoEditViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.placeholderLabel.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderLabel.isHidden = !textView.text.isEmpty
        }
    }
}
