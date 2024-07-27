//
//  SceneDelegate.swift
//  Picha
//
//  Created by t2023-m0032 on 7/22/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = UIWindow(windowScene: scene as! UIWindowScene)
        
        let data = UserDefaults.standard.bool(forKey: "isUser")
        if data {
            window?.rootViewController = TabBarController()
        }
        else {
            window?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
        }
        window?.makeKeyAndVisible()  // show
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

