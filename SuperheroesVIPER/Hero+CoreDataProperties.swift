//
//  Hero+CoreDataProperties.swift
//  SuperheroesVIPER
//
//  Created by Админ on 24.09.2024.
//
//

import Foundation
import CoreData


extension Hero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hero> {
        return NSFetchRequest<Hero>(entityName: "Hero")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var imageURL: String?
    @NSManaged public var category: String?
    @NSManaged public var intelligence: Int16
    @NSManaged public var power: Int16
    @NSManaged public var speed: Int16
    @NSManaged public var endurance: Int16
    @NSManaged public var reaction: Int16
    @NSManaged public var protection: Int16
    @NSManaged public var red: Double
    @NSManaged public var green: Double
    @NSManaged public var blue: Int16
    @NSManaged public var alpha: Int16

}

extension Hero : Identifiable {

}
