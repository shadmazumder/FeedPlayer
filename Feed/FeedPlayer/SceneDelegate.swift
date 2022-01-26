//
//  SceneDelegate.swift
//  FeedPlayer
//
//  Created by Shad Mazumder on 26/1/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    private func configureWindow() {
        window?.rootViewController = RootComposer.rootViewController
        window?.makeKeyAndVisible()
    }
}

