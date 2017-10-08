//
//  ProductMO.swift
//  BuyList
//
//  Created by Ramon Honorio on 06/10/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ProductMO: NSManagedObject {
    // Attributes
    @NSManaged var name: String
    @NSManaged var image: Data
    @NSManaged var value: Float
    
    // Relationship
    @NSManaged var state: StateMO
}
