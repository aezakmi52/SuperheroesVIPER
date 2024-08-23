//
//  SceneDelegate.swift
//  SuperheroesVIPER
//
//  Created by Админ on 20.08.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let superheroesModule = SuperheroesRouter.createModule()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: superheroesModule)
    }
}
    

