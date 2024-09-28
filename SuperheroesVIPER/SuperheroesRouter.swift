//
//  SuperheroesRouter.swift
//  SuperheroesVIPER
//
//  Created by Админ on 21.08.2024.
//

import Foundation
import UIKit

protocol SuperheroesRouterProtocol: AnyObject {
    func navigateToSuperheroDetail(with hero: HeroModel, _ image: UIImage)
}

class SuperheroesRouter: SuperheroesRouterProtocol {
    var viewController: UIViewController?
    
    func navigateToSuperheroDetail(with hero: HeroModel, _ image: UIImage) {
        let detailViewController = DetailViewController()
        
        if let superheroesViewController = viewController as? SuperheroesViewController {
            detailViewController.presenter = superheroesViewController.presenter
            (superheroesViewController.presenter as? SuperheroesPresenter)?.detailView = detailViewController
        }
                
        detailViewController.hero = hero
        detailViewController.image = image
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

