//
//  TotalViewController.swift
//  BuyList
//
//  Created by Ramon Honorio on 04/10/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import UIKit

class TotalViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }

}
