//
//  SuperheroesRouter.swift
//  SuperheroesVIPER
//
//  Created by Админ on 21.08.2024.
//

import Foundation
import UIKit

protocol SuperheroesRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToSuperheroDetail(with hero: HeroModel)
}

class SuperheroesRouter: SuperheroesRouterProtocol {
    var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let viewController = SuperheroesViewController()
        let presenter = SuperheroesPresenter()
        let interactor = SuperheroesInteractor()
        let router = SuperheroesRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
    func navigateToSuperheroDetail(with hero: HeroModel) {
        let detailViewController = SuperheroDetailRouter.createModule(with: hero)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

