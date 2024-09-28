//
//  SuperheroesRemoteDataManager.swift
//  SuperheroesVIPER
//
//  Created by Админ on 28.09.2024.
//

import Foundation
import UIKit


protocol SuperheroesRemoteDataManagerInputProtocol {
    func loadHeroFromServer(with category: HeroModel.HeroCategory)
    func loadImageAsync(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class SuperheroesRemoteDataManager: SuperheroesRemoteDataManagerInputProtocol {
    
    var interactor: SuperheroesInteractorInputProtocol?
    
    func loadHeroFromServer(with category: HeroModel.HeroCategory) {
        
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
                self?.interactor?.heroes = heroes
                DispatchQueue.main.async {
                    self?.interactor?.fetchHeroes(with: category)
                    self?.interactor?.createIdImageDict()
                }
            } catch {
                print("Error decoding heroes: \(error)")
            }
        }
        task.resume()
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
