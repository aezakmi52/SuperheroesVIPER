//
//  SuperheroesInteractor.swift
//  SuperheroesVIPER
//
//  Created by Админ on 20.08.2024.
//

import Foundation
import UIKit


protocol SuperheroesInteractorInputProtocol {
    func fetchHeroes()
    func createIdImageDict()
    func toggleFavorite(id: Int, isFavorite: Bool)
}

final class SuperheroesInteractor: SuperheroesInteractorInputProtocol {
    var heroes: [HeroModel] = []
    var images: [Int: UIImage] = [:]
    
    var presenter: SuperheroesInteractorOutputProtocol?
    
    func fetchHeroes() {
        if heroes.isEmpty {
            if let url = Bundle.main.url(forResource: "Hero", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    heroes = try JSONDecoder().decode([HeroModel].self, from: data)
                } catch {
                    print("Error loading heroes: \(error)")
                }
            }
        }
        presenter?.fetchHeroes(heroes)
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
    }
    
    func createIdImageDict() {
        let dispatchGroup = DispatchGroup()
        
        for hero in heroes {
            if let url = URL(string: hero.imageURL) {
                dispatchGroup.enter()
                
                loadImageAsync(from: url) { [weak self] image in
                    self?.images[hero.id] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.fetchIdImageDict(self?.images ?? [:])
        }
    }
    
    func loadImageAsync(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
}
