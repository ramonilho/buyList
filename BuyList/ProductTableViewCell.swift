//
//  ProductTableViewCell.swift
//  BuyList
//
//  Created by Ramon Honorio on 06/10/17.
//  Copyright © 2017 Evandromon. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var ivCardIcon: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblStateName: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(with product: Product) {
        
        lblProductName.text = product.name
        lblStateName.text = product.state?.name
        lblValue.text = String(format: "U$ %.2f", product.value)
        
        ivPhoto.image = UIImage(data: product.image! as Data)
        ivCardIcon.isHidden = !product.usedCard
        
    }
    
}
