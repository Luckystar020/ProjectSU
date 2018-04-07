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
    let refund:String!
}

class HistoryPayment: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var historyPaymentTable: UITableView!
    
    var UserType : Int!
    var paymentno : String!
    var price : Float!
    var db = Firestore.firestore()
    var WalletID : String = ""
    var dateFormatter = DateFormatter()
    var array = [dataPayment]()
    var Wallet_ID_S :String = ""
    var Wallet_ID_U :String = ""

    override func viewDidLoad() {
        print(self.WalletID)
        db.collection("Wallet").document(self.WalletID).collection("HistoryPayment").getDocuments { (snapshot, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                for document in (snapshot?.documents)!{
                    print(document.documentID )
                    print(document.data()["AmountMoney"] as! Int)
                    print(document.data()["DateTopup"] as! Date)
                    print(document.data()["WalletID_S"] as! String)
                    self.Wallet_ID_S = document.data()["WalletID_S"] as! String
                    self.Wallet_ID_U = document.data()["WalletID_U"] as! String
                    
                    //                    self.dateTopup.append(document.data()["DateTopup"] as Any)
                    self.dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+07:00")! as TimeZone
                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let stringDate = self.dateFormatter.string(from: document.data()["DateTopup"] as! Date)
                    self.array += [dataPayment(paymentno: document.documentID, paymentdate: stringDate, paymentAmount: document.data()["AmountMoney"] as! Int, refund: document.data()["Status"] as! String)]
                    
                }
                print(self.array)
                self.historyPaymentTable.reloadData()
                self.historyPaymentTable.delegate = self
                self.historyPaymentTable.dataSource = self
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!) as! PaymentViewCell
        
        //getting the text of that cell
        let currentItem = currentCell.paymentNo.text
        
        if UserType == 2 && currentCell.statusRefund.text == ""{
        let alert = UIAlertController(title: "Simplified iOS", message: ("Refund Transaction No. : \(String(currentItem!)) ?"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
            let money = currentCell.paymentAmount.text!
            let indexStartOfText = money.index(money.startIndex, offsetBy: 1)
            let indexEndOfText = money.index(money.endIndex, offsetBy: -1)
            let substring3 = money[indexStartOfText..<indexEndOfText]
            self.refunded(WID_U: self.Wallet_ID_U, WID_S: self.Wallet_ID_S, Money: Int(String(substring3))!, Date: NSDate(), DocID: String(currentItem!))
        }))
        
        present(alert, animated: true, completion: nil)
        }
    }
    
    func refunded(WID_U:String, WID_S:String, Money:Int, Date:NSDate, DocID:String){
        
        let collec_s = self.db.collection("Wallet").document(WID_S)
        collec_s.collection("HistoryPayment")
            .document(DocID)
            .updateData([
                "Status" : "Refunded",
                "RefundTime" : Date])
        
        let collec_u = self.db.collection("Wallet").document(WID_U)
        
        collec_u.updateData(["Price" : 2500])
        
        collec_u.collection("HistoryPayment")
            .document(DocID)
            .updateData([
                "Status" : "Refunded",
                "RefundTime" : Date])
    }
    
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return array.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = Bundle.main.loadNibNamed("PaymentViewCell", owner: self, options: nil)?.first as! PaymentViewCell
            if UserType == 1 {
                cell.paymentNo.text = array[indexPath.row].paymentno
                cell.paymentDate.text = array[indexPath.row].paymentdate
                cell.paymentAmount.text = "-" + String(array[indexPath.row].paymentAmount) + "฿"
                cell.statusRefund.text = array[indexPath.row].refund
                cell.paymentAmount.textColor = UIColor.red
            } else if UserType == 2{
                cell.paymentNo.text = array[indexPath.row].paymentno
                cell.paymentDate.text = array[indexPath.row].paymentdate
                cell.paymentAmount.text = "+" + String(array[indexPath.row].paymentAmount) + "฿"
                cell.statusRefund.text = array[indexPath.row].refund
                cell.paymentAmount.textColor = UIColor.green
            }
            return cell
        }
    
    @IBAction func backBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
