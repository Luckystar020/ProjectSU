//
//  PromotionController.swift
//  eWallet
//
//  Created by chain'rong KST on 20/1/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit

class PromotionController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        //show custom nav bar
//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.barTintColor = UIColor(red:0.65, green:0.38, blue:0.09, alpha:1.0)
//        navigationController?.navigationBar.tintColor = UIColor.white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.isHidden = false
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        
        
    }
    
}
