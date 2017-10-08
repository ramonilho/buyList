//
//  Ext+UIViewController.swift
//  ComprasUSA
//
//  Created by Ramon Honorio on 08/10/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
}
