//
//  SceneDelegate.swift
//  GundyMarket
//
//  Created by Gundy on 2/29/24.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let imageCacheManager = ImageDataCacheManager(
            memoryCache: Cache(
                storage: NSCacheStorage(
                    nsCache: .init()
                )
            ),
            diskCache: Cache(
                storage: UserDefaultsCacheStorage(
                    userDefaults: .standard
                )
            ),
            session: NetworkSession(
                session: .shared
            )
        )
        let networkManager = NetworkManager(session: NetworkSession(session: .shared))
        let viewModel = GundyMarketViewModel(
            numberFormatter: numberFormatter,
            dateFormatter: dateFormatter,
            imageCacheManager: imageCacheManager,
            networkManager: networkManager
        )
        let viewController = ProductListViewController(viewModel: viewModel)
        
        window?.rootViewController = UINavigationController(rootViewController: viewController)
    }
}
