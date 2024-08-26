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
        
        let heroesVC = SuperheroesRouter.createModule(for: .superheroes)
        let villainsVC = SuperheroesRouter.createModule(for: .supervillains)
        
        heroesVC.tabBarItem = UITabBarItem(title: "Superheroes", image: UIImage(named: "superheroes"), tag: 0)
        villainsVC.tabBarItem = UITabBarItem(title: "Supervillains", image: UIImage(named: "supervillains"), tag: 1)
        
        let tabBarController = UITabBarController()
        
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = .gray
        tabBarController.tabBar.barTintColor = .clear
        
        let appearance = UITabBarAppearance()
        
        appearance.backgroundColor = .black
        
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        
        tabBarController.viewControllers = [UINavigationController(rootViewController: heroesVC), UINavigationController(rootViewController: villainsVC)]
        
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        window?.rootViewController = tabBarController
    }
}
    

