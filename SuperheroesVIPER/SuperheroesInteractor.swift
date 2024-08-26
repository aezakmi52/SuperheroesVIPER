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
        guard let url = URL(string: "https://aezakmi52.github.io/superheroes-data/Hero.json") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error loading heroes: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let heroes = try JSONDecoder().decode([HeroModel].self, from: data)
                self?.heroes = heroes
                DispatchQueue.main.async {
                    self?.presenter?.fetchHeroes(heroes)
                    self?.createIdImageDict()
                }
            } catch {
                print("Error decoding heroes: \(error)")
            }
        }
        task.resume()
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
