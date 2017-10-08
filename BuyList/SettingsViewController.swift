//
//  SettingsViewController.swift
//  BuyList
//
//  Created by Ramon Honorio on 04/10/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import CoreData
import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet weak var tfDolarQuotation: UITextField!
    @IBOutlet weak var tfIOFTax: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var defaults: UserDefaults!
    var fetchedResultsController: NSFetchedResultsController<State>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupSettingsBundle), name: UserDefaults.didChangeNotification, object: nil)
        
        setupViews()
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSettingsBundle()
    }
    
    func setupSettingsBundle(){
        defaults = UserDefaults.standard
        
        tfDolarQuotation.text = defaults.string(forKey: "dolarQuotation")
        tfIOFTax.text = defaults.string(forKey: "iof")
    }
    
    func setupViews() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    @IBAction func addState(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Adicionar estado", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Nome do estado"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Imposto"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { (alert) in
            
            guard
                let stateName = alertController.textFields?[0].text,
                let stateTax = alertController.textFields?[1].text,
                Validate.text(stateName),
                Validate.text(stateTax) else {
                    self.showSimpleAlert(title: "Erro", message: "Não foi possível salvar pois os campos estavam com dados incorretos")
                    return
            }
            
            let state = State(context: self.context)
            state.name = stateName
            state.tax = Float(stateTax)!
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            
            // Refresh pickerView when back
            if let topVC = UIApplication.topViewController() as? CreateProductViewController {
                topVC.loadStates()
                topVC.setupPickerView()
            }
            
        }
    }
    
}

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        
        let state = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tax)"
        cell.detailTextLabel?.textColor = UIColor.red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Editar estado", message: nil, preferredStyle: .alert)
        
        let state = self.fetchedResultsController.object(at: indexPath)
        
        alertController.addTextField { (textField) in
            textField.text = state.name
            textField.placeholder = "Nome do estado"
        }
        alertController.addTextField { (textField) in
            textField.text = "\(state.tax)"
            textField.placeholder = "Imposto"
            textField.keyboardType = .decimalPad
        }
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { alert in
            tableView.deselectRow(at: indexPath, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Editar", style: .default, handler: { (alert) in
            tableView.deselectRow(at: indexPath, animated: true)
            guard
                let stateName = alertController.textFields?[0].text,
                let stateTax = alertController.textFields?[1].text,
                Validate.text(stateName),
                Validate.text(stateTax) else {
                    self.showSimpleAlert(title: "Erro", message: "Não foi possível salvar pois os campos estavam com dados incorretos")
                    return
            }
            
            
            state.name = stateName
            state.tax = Float(stateTax)!
            
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let state = fetchedResultsController.object(at: indexPath)
            context.delete(state)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension SettingsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
