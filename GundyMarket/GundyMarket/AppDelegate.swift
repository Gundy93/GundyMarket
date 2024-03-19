//
//  AppDelegate.swift
//  GundyMarket
//
//  Created by Gundy on 2/29/24.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    let user = User(
        id: Bundle.main.object(forInfoDictionaryKey: "UserID") as! Int,
        name: Bundle.main.object(forInfoDictionaryKey: "UserName") as! String
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
