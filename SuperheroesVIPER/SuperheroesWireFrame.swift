//
//  Adjuster.swift
//  SuperheroesVIPER
//
//  Created by Админ on 24.09.2024.
//

import Foundation
import UIKit


protocol SuperheroesWireFrameProtocol {
    static func createModule(for category: HeroModel.HeroCategory) -> UIViewController
}

class SuperheroesWireFrame: SuperheroesWireFrameProtocol {
    static func createModule(for category: HeroModel.HeroCategory) -> UIViewController {
        
        let superheroesViewController = SuperheroesViewController(category: category)
        let interactor = SuperheroesInteractor()
        let presenter = SuperheroesPresenter()
        let router = SuperheroesRouter()
        let remoteDataManager = SuperheroesRemoteDataManager()
        
        superheroesViewController.presenter = presenter
        presenter.view = superheroesViewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = superheroesViewController
        remoteDataManager.interactor = interactor
        interactor.remoteDataManager = remoteDataManager
        
        return superheroesViewController
    }

}
