//
//  HistoryPayment.swift
//  eWallet
//
//  Created by chain'rong KST on 14/12/2560 BE.
//  Copyright © 2560 chain'rong KST. All rights reserved.
//

import UIKit

class HistoryPayment: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var historyPaymentTable: UITableView!
    
    var paymentno : String!
    var price : Float!
    
    let paymentNumber = ["FFF","AAA","BBB"]
    let priceCell = [1234,111,555]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyPaymentTable.dequeueReusableCell(withIdentifier: "Payment")
        
//        cell?.textLabel?.text = paymentNumber[indexPath.row]
//        cell?.detailTextLabel?.text = ("\(priceCell[indexPath.row])")
        
        return cell!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        historyPaymentTable.delegate = self
        historyPaymentTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
}
