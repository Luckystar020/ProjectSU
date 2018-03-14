//
//  PaymentViewCell.swift
//  eWallet
//
//  Created by chain'rong KST on 17/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit

class PaymentViewCell: TableViewCell {

    @IBOutlet weak var paymentNo: UILabel!
    @IBOutlet weak var paymentDate: UILabel!
    @IBOutlet weak var paymentAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
