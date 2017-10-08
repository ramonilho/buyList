//
//  StateMO.swift
//  BuyList
//
//  Created by Ramon Honorio on 06/10/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class StateMO: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var tax: Float
}
