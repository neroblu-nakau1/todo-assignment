// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

class ViewController: UIViewController {

    /// 自身のインスタンスを生成する
    /// - returns: 新しい自身のインスタンス
    class func create() -> ViewController {
        let ret = App.Storyboard("List").get(ViewController.self)
        return ret
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        App.API.request(TestRequest(zipcode: "541-0041")) { response, result in
//            
//            print(response!)
//        }
//    }
}
