//
//  AppDelegate.swift
//  SuperheroesVIPER
//
//  Created by Админ on 20.08.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SuperheroesVIPER")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let heroesVC = SuperheroesWireFrame.createModule(for: .superheroes)
        let villainsVC = SuperheroesWireFrame.createModule(for: .supervillains)
        
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
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

