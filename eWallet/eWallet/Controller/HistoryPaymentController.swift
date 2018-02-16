//
//  HistoryPayment.swift
//  eWallet
//
//  Created by chain'rong KST on 14/12/2560 BE.
//  Copyright © 2560 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

class HistoryPayment: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var historyPaymentTable: UITableView!
    
    var paymentno : String!
    var price : Float!
    var db = Firestore.firestore()
    var WID : String = ""
    
    let paymentNumber = ["FFF","AAA","BBB"]
    let priceCell = [1234,111,555]
//    var dateTopup : Array = [NSDate]
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.WID)
        
        
        
        
        // Do any additional setup after loading the view.
        historyPaymentTable.delegate = self
        historyPaymentTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //show custom nav bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.65, green:0.38, blue:0.09, alpha:1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyPaymentTable.dequeueReusableCell(withIdentifier: "Payment")
        
        
        //        cell?.textLabel?.text = paymentNumber[indexPath.row]
        //        cell?.detailTextLabel?.text = ("\(priceCell[indexPath.row])")
        
        return cell!
    }
    

    
}
