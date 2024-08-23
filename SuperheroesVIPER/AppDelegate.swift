//
//  AppDelegate.swift
//  SuperheroesVIPER
//
//  Created by Админ on 20.08.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let superheroesModule = SuperheroesRouter.createModule()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: superheroesModule)
        window?.makeKeyAndVisible()
        return true
    }
}

