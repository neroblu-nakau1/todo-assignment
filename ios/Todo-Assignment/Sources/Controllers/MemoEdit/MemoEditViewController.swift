// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class MemoEditViewController: UIViewController {
    
    @IBOutlet fileprivate weak var textView: UITextView!
    
    /// インスタンスを生成する
    /// - returns: 新しいインスタンス
    class func create() -> UINavigationController {
        let ret = App.Storyboard("MemoEdit").get(UINavigationController.self)
        return ret
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextView()
        self.setupNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.becomeFirstResponder()
    }
    
    
    
    private func setupTextView() {
        self.textView.scrollRangeToVisible(NSMakeRange(0, 1))
        
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.textView.textContainerInset = UIEdgeInsets.zero
//        self.textView.textContainer.lineFragmentPadding = 0
    }
    
    private func setupNavigationItem() {
        let item = UIBarButtonItem(
            title: "完了",
            style: .done,
            target: self,
            action: #selector(didTapFinishButton))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc private func didTapFinishButton() {
        print(1)
    }
}
