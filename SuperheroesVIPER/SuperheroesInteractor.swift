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
    func toggleFavorite(id: Int, isFavorite: Bool, category: HeroModel.HeroCategory) -> Void
    func toggleFavoriteFilter(heroes: [HeroModel], filterState: Bool, category: HeroModel.HeroCategory)
    var heroes: [HeroModel] { get set }
}

final class SuperheroesInteractor: SuperheroesInteractorInputProtocol {
    var heroes: [HeroModel]
    var images: [Int: UIImage] = [:]
    
    var presenter: SuperheroesInteractorOutputProtocol?
    var remoteDataManager: SuperheroesRemoteDataManagerInputProtocol?
    var localDataManager: SuperheroesLocalDataManagerInputProtocol?
    
    init() {
        do {
            self.heroes = try (localDataManager?.retrieveHeroes().map() {
                return HeroModel(
                    id: Int($0.id),
                    name: $0.name!,
                    category: HeroModel.HeroCategory(rawValue: $0.category!)!,
                    stats: HeroModel.HeroStats(
                        intelligence: Int($0.intelligence),
                        power: Int($0.power),
                        speed: Int($0.speed),
                        endurance: Int($0.endurance),
                        reaction: Int($0.reaction),
                        protection: Int($0.protection)
                    ),
                    isFavorite: $0.isFavorite,
                    imageURL: $0.imageURL ?? "",
                    color: HeroModel.RGBAColor(
                        red: $0.red,
                        green: $0.green,
                        blue: $0.blue,
                        alpha: $0.alpha
                    )
                )
            }) ?? []
        } catch {
            self.heroes = []
        }
    }
    
    func fetchHeroes(with category: HeroModel.HeroCategory) {
        if heroes.isEmpty {
            do {
                try localDataManager?.clearHeroes()
                if let savedHeroes = try localDataManager?.retrieveHeroes(), !savedHeroes.isEmpty {
                    self.heroes = savedHeroes.map {
                        return HeroModel(
                            id: Int($0.id),
                            name: $0.name!,
                            category: HeroModel.HeroCategory(rawValue: $0.category!)!,
                            stats: HeroModel.HeroStats(
                                intelligence: Int($0.intelligence),
                                power: Int($0.power),
                                speed: Int($0.speed),
                                endurance: Int($0.endurance),
                                reaction: Int($0.reaction),
                                protection: Int($0.protection)
                            ),
                            isFavorite: $0.isFavorite,
                            imageURL: $0.imageURL ?? "",
                            color: HeroModel.RGBAColor(
                                red: $0.red,
                                green: $0.green,
                                blue: $0.blue,
                                alpha: $0.alpha
                            )
                        )
                    }
                    presenter?.fetchHeroes(heroes.filter { $0.category == category })
                } else {
                    fetchFromServerAndSave(category: category)
                }
            } catch {
                fetchFromServerAndSave(category: category)
            }
        } else {
            presenter?.fetchHeroes(heroes.filter { $0.category == category })
        }
    }

    private func fetchFromServerAndSave(category: HeroModel.HeroCategory) {
        remoteDataManager?.loadHeroFromServer(with: category) { [weak self] heroesFromServer in
            guard let self = self else { return }

            for hero in heroesFromServer {
                try? self.localDataManager?.saveHero(hero)
            }
            
            self.heroes = heroesFromServer

            let filteredHeroes = heroesFromServer.filter { $0.category == category }
            self.presenter?.fetchHeroes(filteredHeroes)
        }
    }
    
    func toggleFavorite(id: Int, isFavorite: Bool, category: HeroModel.HeroCategory) -> Void {
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
        presenter?.fetchHeroes(heroes.filter { $0.category == category })
        presenter?.fetchHero(heroes.first { $0.id == id }!)
        saveHeroes(heroes: self.heroes)
    }
    
    func saveHeroes(heroes: [HeroModel]) {
        do {
            for hero in heroes {
                try? localDataManager?.saveHero(hero)
            }
        }
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
    
    func toggleFavoriteFilter(heroes: [HeroModel], filterState: Bool, category: HeroModel.HeroCategory) {
        if filterState {
            let displayHeroes = heroes.filter { $0.isFavorite == true }
            presenter?.fetchHeroes(displayHeroes)
        } else {
            presenter?.fetchHeroes(self.heroes.filter { $0.category == category })
        }
    }
}
