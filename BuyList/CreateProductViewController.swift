//
//  CreateProductViewController.swift
//  BuyList
//
//  Created by Ramon Honorio on 29/09/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import UIKit
import CoreData

class CreateProductViewController: BaseViewController {
    
    typealias FormFields = (isValid: Bool, product: Product?)
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    
    var imagePicker: UIImagePickerController!
    var pickerView: UIPickerView!
    var fetchedStatesController: NSFetchedResultsController<State>!
    
    var states: [State] = [State]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Gesture recognizer for picture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getPicture))
        ivPicture.addGestureRecognizer(tapGesture)
        
        loadStates()
        setupPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard pickerView != nil else { return }
        pickerView.reloadAllComponents()
    }
    
    func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        
        let toolbar = UIToolbar()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissKeyboard))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolbar
        
        // Clear state field if it doesnt exist
        let namesOfStates = states.flatMap { $0.name }
        if namesOfStates.contains(tfState.text ?? "") == false {
            tfState.text = ""
        }
        
    }
    
    func donePicker() {
        dismissKeyboard()
        if states.isEmpty {
            return
        }
        tfState.text = states[pickerView.selectedRow(inComponent: 0)].name ?? ""
    }
    
    func getPicture() {
        let alertController = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(UIAlertAction(title: "Câmera", style: .default, handler: { (alert) in
                self.imagePicker = UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: { (alert) in
                self.imagePicker = UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func getFields() -> FormFields {
        
        guard
            let name = tfName.text,
            let state = tfState.text,
            let value = tfValue.text,
            let picture = ivPicture.image else {
            return (false, nil)
        }
        
        guard
            Validate.text(name),
            Validate.text(state),
            Validate.text(value),
            picture != UIImage(named: "image-add") else {
                // Valida todos os campos, caso contrario mostra um alerta
                showSimpleAlert(title: "Campos inválidos", message: "Por favor, preencha todos os campos corretamente.")
            return (false, nil)
        }
        
        let product = Product(context: context)
        
        product.name = name
        product.state = states[pickerView.selectedRow(inComponent: 0)]
        product.usedCard = swCard.isOn
        product.value = Float(value)!
        product.image = UIImagePNGRepresentation(picture)! as NSData
        
        return (true, product)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedStatesController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedStatesController.delegate = self
        do {
            try fetchedStatesController.performFetch()
            
            if let fetchedStates = fetchedStatesController.fetchedObjects {
                self.states = fetchedStates
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    @IBAction func createProduct(_ sender: Any) {
        let form = getFields()
        
        if form.isValid {
            do {
                try context.save()
                
                let alertController = UIAlertController(title: "Sucesso!", message: "O produto foi salvo. Visualize-o agora na sua lista.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                present(alertController, animated: true, completion: nil)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addState(_ sender: Any) {
        let settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC")
        
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            // Refresh tableView when back
            if let topVC = UIApplication.topViewController() as? BuyListViewController {
                topVC.tableView.reloadData()
            }
        }
    }
    
}

extension CreateProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ivPicture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        ivPicture.contentMode = .scaleAspectFit
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension CreateProductViewController: UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name
    }
}

extension CreateProductViewController : NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let fetchedStates = fetchedStatesController.fetchedObjects {
            self.states = fetchedStates
            self.setupPickerView()
        }
    }
}
