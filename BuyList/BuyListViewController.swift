//
//  BuyListViewController.swift
//  BuyList
//
//  Created by Ramon Honorio on 29/09/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import CoreData
import UIKit

enum ProductViewType {
    case create
    case edit
}

class BuyListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var fetchedProductsController: NSFetchedResultsController<Product>!
    var products: [Product] = [Product]()
    
    var goToProductAs: ProductViewType = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let btnAddProduct = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))
        
        navigationItem.rightBarButtonItem = btnAddProduct
    }
    
    func addProduct() {
        self.performSegue(withIdentifier: "createProduct", sender: self)
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
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension BuyListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        
        cell.setup(with: products[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = fetchedProductsController.object(at: indexPath)
            context.delete(state)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "createProduct", sender: products[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? CreateProductViewController {
            if let product = sender as? Product {
                dvc.viewType = .edit
                dvc.product = product
            } else {
                dvc.viewType = .create
            }
        }
        
    }
    
}

extension BuyListViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        products = fetchedProductsController.fetchedObjects!
        tableView.reloadData()
    }
}



