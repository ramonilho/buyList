//
//  TotalViewController.swift
//  BuyList
//
//  Created by Ramon Honorio on 04/10/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import CoreData
import UIKit

class TotalViewController: BaseViewController {

    @IBOutlet weak var lblTotalDolar: UILabel!
    @IBOutlet weak var lblTotalReal: UILabel!
    
    var fetchedProductsController: NSFetchedResultsController<Product>!
    var products = [Product]()
    
    var totalDolar: Float = 0
    var totalReal: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProducts()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedProductsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedProductsController.delegate = self
        do {
            try fetchedProductsController.performFetch()
            self.products = fetchedProductsController.fetchedObjects!
            updateLabels()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateLabels() {
        let dolarTax = Float(UserDefaults.standard.string(forKey: "dolarQuotation") ?? "0")!
        
        totalDolar = 0
        totalReal = 0
        
        for p in products {
            
            totalDolar += p.value
            totalReal += p.value * dolarTax
            
            if p.usedCard {
                totalReal += p.value * p.state!.tax
            }
            
        }
        
        lblTotalDolar.text = String(format: "%.2f", totalDolar)
        lblTotalReal.text = String(format: "%.2f", totalReal)
    }

}

extension TotalViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        products = fetchedProductsController.fetchedObjects!
        updateLabels()
    }
}
