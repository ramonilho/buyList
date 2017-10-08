//
//  State+CoreDataProperties.swift
//  
//
//  Created by Ramon Honorio on 08/10/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }

    @NSManaged public var name: String?
    @NSManaged public var tax: Float
    @NSManaged public var products: NSSet?

}

// MARK: Generated accessors for products
extension State {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
