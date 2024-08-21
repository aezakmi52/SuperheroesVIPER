//
//  SuperheroesInteractor.swift
//  SuperheroesVIPER
//
//  Created by Админ on 20.08.2024.
//

import Foundation



protocol SuperheroesInteractorInputProtocol {
    func fetchHeroes()
    func toggleFavorite(id: Int, isFavorite: Bool, heroes: inout [HeroModel]) -> Void
    func getHeroById(by id: Int, heroes: [HeroModel]) -> HeroModel
}

final class SuperheroesInteractor: SuperheroesInteractorInputProtocol {
    var heroes: [HeroModel] = []
    
    var presenter: SuperheroesInteractorOutputProtocol?
    
    func fetchHeroes() {
        if heroes.isEmpty {
            if let url = Bundle.main.url(forResource: "Hero", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    heroes = try JSONDecoder().decode([HeroModel].self, from: data)
                } catch {
                    print("Error loading tasks: \(error)")
                }
            }
        }
        presenter?.fetchHeroes(heroes)
    }
    
    func toggleFavorite(id: Int, isFavorite: Bool, heroes: inout [HeroModel]) -> Void {
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
    }
    
    func getHeroById(by id: Int, heroes: [HeroModel]) -> HeroModel {
        let hero: HeroModel = heroes.first { $0.id == id } ?? heroes[id - 1]
        return hero
    }
}
