//
//  SuperheroesRouter.swift
//  SuperheroesVIPER
//
//  Created by Админ on 21.08.2024.
//

import Foundation
import UIKit

protocol SuperheroesRouterProtocol: AnyObject {
    func createModule() -> UIViewController
}

class SuperheroesRouter: SuperheroesRouterProtocol {
    func createModule() -> UIViewController {
        let viewController = SuperheroesViewController()
        let presenter = SuperheroesPresenter()
        let interactor = SuperheroesInteractor()
        let router = SuperheroesRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
}

