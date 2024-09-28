//
//  SuperheroesInteractor.swift
//  SuperheroesVIPER
//
//  Created by Админ on 20.08.2024.
//

import Foundation
import UIKit


protocol SuperheroesInteractorInputProtocol {
    func fetchHeroes(with category: HeroModel.HeroCategory)
    func createIdImageDict()
    func toggleFavorite(id: Int, isFavorite: Bool)
    func toggleFavoriteFilter(heroes: [HeroModel], filterState: Bool)
    var heroes: [HeroModel] { get set }
}

final class SuperheroesInteractor: SuperheroesInteractorInputProtocol {
    var heroes: [HeroModel] = []
    var images: [Int: UIImage] = [:]
    
    var presenter: SuperheroesInteractorOutputProtocol?
    var remoteDataManager: SuperheroesRemoteDataManagerInputProtocol?
    
    func fetchHeroes(with category: HeroModel.HeroCategory) {
        if heroes.isEmpty {
            remoteDataManager?.loadHeroFromServer(with: category)
        } else {
            presenter?.fetchHeroes(heroes.filter { $0.category == category })
        }
    }
    
    func toggleFavorite(id: Int, isFavorite: Bool) -> Void {
        heroes = heroes.map { hero in
            if hero.id == id {
                return HeroModel(id: id,
                                 name: hero.name,
                                 category: hero.category,
                                 stats: hero.stats,
                                 isFavorite: isFavorite,
                                 imageURL: hero.imageURL,
                                 color: hero.color)
            } else {
                return hero
            }
        }
        presenter?.fetchHeroes(heroes)
        presenter?.fetchHero(heroes.first { $0.id == id }!)
    }
    
    func createIdImageDict() {
        let dispatchGroup = DispatchGroup()
        
        for hero in heroes {
            if let url = URL(string: hero.imageURL) {
                dispatchGroup.enter()
                
                remoteDataManager?.loadImageAsync(from: url) { [weak self] image in
                    self?.images[hero.id] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.fetchIdImageDict(self?.images ?? [:])
        }
    }
    
    func toggleFavoriteFilter(heroes: [HeroModel], filterState: Bool) {
        if filterState {
            let displayHeroes = heroes.filter { $0.isFavorite == true }
            presenter?.fetchHeroes(displayHeroes)
        } else {
            presenter?.fetchHeroes(self.heroes)
        }
    }
}
