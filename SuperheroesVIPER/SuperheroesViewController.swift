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
}

class SuperheroesViewController: UIViewController, SuperheroesViewProtocol {
    var heroes: [HeroModel] = []
    var presenter: SuperheroesPresenterProtocol?
    
    func showHeroes(_ heroes: [HeroModel]) {
        self.heroes = heroes
    }
}
