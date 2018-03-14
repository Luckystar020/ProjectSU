//
//  TableViewCell.swift
//  eWallet
//
//  Created by chain'rong KST on 15/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var Topupno: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var AmountMoney: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
