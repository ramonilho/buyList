//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Ramon Honorio on 08/10/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var usedCard: Bool
    @NSManaged public var value: Float
    @NSManaged public var state: State?

}
