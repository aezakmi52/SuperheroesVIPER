//
//  SuperheroesLocalDataManager.swift
//  SuperheroesVIPER
//
//  Created by Админ on 28.09.2024.
//

import Foundation
import CoreData
import UIKit


protocol SuperheroesLocalDataManagerInputProtocol {
    func saveHero(_ hero: HeroModel) throws
    func retrieveHeroes() throws -> [Hero]
    func clearHeroes() throws
}

class SuperheroesLocalDataManager: SuperheroesLocalDataManagerInputProtocol {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveHero(_ hero: HeroModel) throws {
        let entity = NSEntityDescription.entity(forEntityName: "Hero", in: managedObjectContext)!
        let heroObject = NSManagedObject(entity: entity, insertInto: managedObjectContext) as! Hero
        
        heroObject.id = Int16(hero.id)
        heroObject.name = hero.name
        heroObject.category = hero.category.rawValue
        heroObject.isFavorite = hero.isFavorite
        heroObject.intelligence = Int16(hero.stats.intelligence)
        heroObject.power = Int16(hero.stats.power)
        heroObject.speed = Int16(hero.stats.speed)
        heroObject.endurance = Int16(hero.stats.endurance)
        heroObject.reaction = Int16(hero.stats.reaction)
        heroObject.protection = Int16(hero.stats.protection)
        heroObject.imageURL = hero.imageURL
        heroObject.red = hero.color.red
        heroObject.green = hero.color.green
        heroObject.blue = hero.color.blue
        heroObject.alpha = hero.color.alpha
        
        try managedObjectContext.save()
    }
    
    func retrieveHeroes() throws -> [Hero] {
        let fetchRequest: NSFetchRequest<Hero> = Hero.fetchRequest()
        return try managedObjectContext.fetch(fetchRequest)
    }
    
    func clearHeroes() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Hero.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try managedObjectContext.execute(deleteRequest)
    }
}
