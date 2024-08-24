//
//  SuperheroesPresenter.swift
//  SuperheroesVIPER
//
//  Created by Админ on 21.08.2024.
//

import Foundation
import UIKit

protocol SuperheroesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectHero(_ hero: HeroModel, _ image: UIImage)
    func didToggleFavorite(for hero: HeroModel)
}

protocol SuperheroesInteractorOutputProtocol: AnyObject {
    func fetchHeroes(_ heroes: [HeroModel])
    func fetchIdImageDict(_ images: [Int: UIImage])
    func fetchHero(_ hero: HeroModel)
}

class SuperheroesPresenter: SuperheroesPresenterProtocol {
    
    var view: SuperheroesViewProtocol?
    var detailView: SuperheroDetailViewProtocol?
    
    var interactor: SuperheroesInteractorInputProtocol?
    var router: SuperheroesRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchHeroes()
        interactor?.createIdImageDict()
    }
    
    func didSelectHero(_ hero: HeroModel, _ image: UIImage) {
        router?.navigateToSuperheroDetail(with: hero, image)
    }
    
    func didToggleFavorite(for hero: HeroModel) {
        interactor?.toggleFavorite(id: hero.id, isFavorite: !hero.isFavorite)
    }
}

extension SuperheroesPresenter: SuperheroesInteractorOutputProtocol {
    func fetchHeroes(_ heroes: [HeroModel]) {
        view?.showHeroes(heroes)
    }
    
    func fetchIdImageDict(_ images: [Int: UIImage]) {
        view?.getImages(images)
    }
    
    func fetchHero(_ hero: HeroModel) {
        detailView?.showSuperheroDetail(hero)
    }
}


