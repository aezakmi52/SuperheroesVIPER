//
//  SuperheroesViewController.swift
//  SuperheroesVIPER
//
//  Created by Админ on 21.08.2024.
//

import Foundation
import UIKit

protocol SuperheroesViewProtocol: AnyObject {
    func showHeroes(_ heroes: [HeroModel])
    func getImages(_ images: [Int: UIImage])
}

class SuperheroesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SuperheroesViewProtocol {
    var heroes: [HeroModel] = []
    
    var images: [Int: UIImage] = [:]
    
    var presenter: SuperheroesPresenterProtocol?
    
    var displayHeroes: [HeroModel] = []
    
    var tableView = UITableView()
    
    var favoriteOnly = false {
        didSet {
            let image = favoriteOnly ? UIImage(named: "star.fill") : UIImage(named: "star")
            navigationItem.rightBarButtonItem?.image = image
            
            displayHeroes = favoriteOnly ? heroes.filter {$0.isFavorite == true} : heroes.filter { $0.category == .superheroes }
            tableView.reloadData()
        }
    }
    
    func getImages(_ images: [Int: UIImage]) {
        self.images = images
        tableView.reloadData()
    }
    
    func showHeroes(_ heroes: [HeroModel]) {
        self.heroes = heroes
        self.displayHeroes = heroes.filter { $0.category == .superheroes }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad()
        setupFavoriteFilterButton()
        tableView.reloadData()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.clear]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .clear
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HeroTableViewCell.self, forCellReuseIdentifier: "HeroCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.rowHeight = 220
        view.addSubview(tableView)
        title = HeroModel.HeroCategory.superheroes.rawValue.capitalized
    }
    
    func setupFavoriteFilterButton() {
        let favoriteFilterButton = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(toggleFavoriteFilter))
        favoriteFilterButton.tintColor = UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1)
        navigationItem.rightBarButtonItem = favoriteFilterButton
    }
    
    @objc func toggleFavoriteFilter() {
        favoriteOnly.toggle()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayHeroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! HeroTableViewCell
        cell.selectionStyle = .none
        let hero = displayHeroes[indexPath.row]
        let image = images[hero.id]
        cell.configure(with: hero, image: image)
        cell.favoriteButtonAction = { [weak self] in
            self?.presenter?.didToggleFavorite(for: hero)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = displayHeroes[indexPath.row]
        let image = images[hero.id] ?? UIImage()
        presenter?.didSelectHero(hero, image)
    }
}
