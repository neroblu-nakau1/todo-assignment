// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
// TODOアプリ
// Created by NAKAYASU Yuichi
// - * - * - * - * - * - * - * - * - * - * - * - * - * - * - *
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.configureNavigationBar()
        return true
    }
    
    private func configureNavigationBar() {
        UINavigationBar.appearance().tintColor    = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.596, green: 0.725, blue: 0.976, alpha: 1.0)
    }
}
