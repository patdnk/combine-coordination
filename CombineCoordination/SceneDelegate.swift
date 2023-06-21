//
//  SceneDelegate.swift
//  CombineCoordination
//
//  Created by Pat on 13/01/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CombineCancellableHolder {

    var window: UIWindow?
    private (set) lazy var appCoordinator = AppCoordinator()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        appCoordinator.start(window: window)
            .sink { }
            .store(in: &cancellables)
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

}
