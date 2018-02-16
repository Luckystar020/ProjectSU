//
//  PromotionViewCell.swift
//  eWallet
//
//  Created by chain'rong KST on 16/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit

class PromotionViewCell: TableViewCell {

    @IBOutlet weak var proImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
