//
//  BaseViewController.swift
//  BuyList
//
//  Created by Ramon Honorio on 06/10/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import EmptyDataSet_Swift

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showSimpleAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissKeyboard()
    }

}

extension BaseViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Sua lista está vazia!", attributes: [NSForegroundColorAttributeName: UIColor.darkGray])
    }
}
