//
//  DetailViewController.swift
//  SuperheroesVIPER
//
//  Created by Админ on 21.08.2024.
//

import UIKit

// MARK: - DetailViewController

protocol SuperheroDetailViewProtocol: AnyObject {
    func showSuperheroDetail(_ hero: HeroModel)
}


class DetailViewController: UIViewController, SuperheroDetailViewProtocol {
    
    // MARK: - Properties
    
    var presenter: SuperheroesPresenterProtocol?
    
    var hero: HeroModel! {
        didSet {
            updateUI()
        }
    }
    var image: UIImage?
    
    let heroImage = UIImageView()
    let name = UILabel()
    let statsStack = UIStackView()
    let valueStack = UIStackView()
    let favoriteButton = UIButton()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad(with: hero.category)
    }
    
    // MARK: - Setup Methods
    
    func showSuperheroDetail(_ hero: HeroModel) {
        self.hero = hero
        updateUI()
    }
    
    func setupView() {
        navigationController?.navigationBar.tintColor = .white
    
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [hero.color.outputColor.cgColor, UIColor.black.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradient, at: 0)
        
        name.text = hero.name.capitalized
        name.textColor = .white
        name.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        heroImage.image = image
        
        let statsArray = ["INTELLIGENCE", "POWER", "SPEED", "ENDURANCE", "REACTION", "PROTECTION"]
        
        let valueArray = [hero.stats.intelligence, hero.stats.power, hero.stats.speed, hero.stats.endurance, hero.stats.reaction, hero.stats.protection]
        
        for value in valueArray {
            let label = UILabel()
            label.text = "\(value)"
            label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            label.textColor = .white
            valueStack.addArrangedSubview(label)
        }
        
        for stat in statsArray {
            let label = UILabel()
            label.text = "\(stat)"
            label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            label.textColor = UIColor(white: 1, alpha: 0.38)
            statsStack.addArrangedSubview(label)
        }
        
        statsStack.axis = .vertical
        statsStack.spacing = 16
        
        valueStack.axis = .vertical
        valueStack.spacing = 16
        
        favoriteButton.setTitle(hero.isFavorite ? "In favorites" : "Add to favorites", for: .normal)
        favoriteButton.setTitleColor(hero.isFavorite ? .black : UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1), for: .normal)
        favoriteButton.backgroundColor = (hero.isFavorite ? UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1) : .black)
        favoriteButton.layer.cornerRadius = 16
        favoriteButton.layer.borderWidth = 2
        favoriteButton.layer.borderColor = CGColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        valueStack.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(heroImage)
        view.addSubview(name)
        view.addSubview(statsStack)
        view.addSubview(valueStack)
        view.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            heroImage.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 50),
            heroImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heroImage.widthAnchor.constraint(equalToConstant: 164),
            heroImage.heightAnchor.constraint(equalToConstant: 164),
            
            statsStack.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: 40),
            statsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            
            valueStack.trailingAnchor.constraint(equalTo: statsStack.leadingAnchor, constant: -20),
            valueStack.topAnchor.constraint(equalTo: statsStack.topAnchor),
            
            favoriteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            favoriteButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func updateUI() {
        favoriteButton.setTitle(hero.isFavorite ? "In favorites" : "Add to favorites", for: .normal)
        favoriteButton.setTitleColor(hero.isFavorite ? .black : UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1), for: .normal)
        favoriteButton.backgroundColor = (hero.isFavorite ? UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1) : .black)
    }
    
    @objc func favoriteButtonTapped() {
        presenter?.didToggleFavorite(for: hero)
    }
}
