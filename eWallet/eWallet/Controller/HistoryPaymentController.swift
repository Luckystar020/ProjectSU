//
//  HistoryPayment.swift
//  eWallet
//
//  Created by chain'rong KST on 14/12/2560 BE.
//  Copyright © 2560 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct dataPayment {
    let paymentno: String!
    let paymentdate:String!
    let paymentAmount:Int!
}

class HistoryPayment: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var historyPaymentTable: UITableView!
    
    var paymentno : String!
    var price : Float!
    var db = Firestore.firestore()
    var WID : String = ""
    var dateFormatter = DateFormatter()
    var array = [dataPayment]()

    override func viewDidLoad() {
        print(self.WID)
        db.collection("wallet").document(self.WID).collection("HistoryTopup").getDocuments { (snapshot, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                for document in (snapshot?.documents)!{
                    print(document.documentID )
                    print(document.data()["AmountMoney"] as! Int)
                    print(document.data()["DateTopup"] as! Date)
                    print(document.data()["WID"] as! String)
                    //                    self.dateTopup.append(document.data()["DateTopup"] as Any)
                    self.dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+07:00")! as TimeZone
                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let stringDate = self.dateFormatter.string(from: document.data()["DateTopup"] as! Date)
                    self.array += [dataPayment(paymentno: document.documentID, paymentdate: stringDate, paymentAmount: document.data()["AmountMoney"] as! Int)]
                    
                }
                print(self.array)
                self.historyPaymentTable.reloadData()
                self.historyPaymentTable.delegate = self
                self.historyPaymentTable.dataSource = self
            }
        }
    }
    
    
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return array.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = Bundle.main.loadNibNamed("PaymentViewCell", owner: self, options: nil)?.first as! PaymentViewCell
            cell.paymentNo.text = array[indexPath.row].paymentno
            cell.paymentDate.text = array[indexPath.row].paymentdate
            cell.paymentAmount.text = "+" + String(array[indexPath.row].paymentAmount) + "฿"
            return cell
        }
    
    @IBAction func backBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
