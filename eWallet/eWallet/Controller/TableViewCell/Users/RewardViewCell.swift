//
//  RewardViewCell.swift
//  eWallet
//
//  Created by chain'rong KST on 17/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit

class RewardViewCell: TableViewCell {

    @IBOutlet weak var rewardNo: UILabel!
    @IBOutlet weak var rewardDate: UILabel!
    @IBOutlet weak var RewardPoint: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
