//
//  SuperheroesPresenter.swift
//  SuperheroesVIPER
//
//  Created by Админ on 21.08.2024.
//

import Foundation

protocol SuperheroesPresenterProtocol: AnyObject {
    func viewDidLoad()
}

protocol SuperheroesInteractorOutputProtocol: AnyObject {
    func fetchHeroes(_ heroes: [HeroModel])
}

class SuperheroesPresenter: SuperheroesPresenterProtocol {
    
    var view: SuperheroesViewProtocol?
    var interactor: SuperheroesInteractorInputProtocol?
    var router: SuperheroesRouterProtocol?
    
    func viewDidLoad() {
        
    }
}

extension SuperheroesPresenter: SuperheroesInteractorOutputProtocol {
    func fetchHeroes(_ heroes: [HeroModel]) {
        view?.showHeroes(heroes)
    }
}


