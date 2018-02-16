//
//  HistoryTopupViewController.swift
//  eWallet
//
//  Created by chain'rong KST on 15/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct cellData {
    let Topupno : String!
    let Date : String!
    let AmountMoney: Int!
}

class HistoryTopupViewController:  UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    var db = Firestore.firestore()
    var WID : String = ""
    var countarr = [cellData]()
    let dateFormatter = DateFormatter()

    @IBOutlet weak var tableTopup: UITableView!
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        
//        let stringDate = dateFormatter.string(from: Date())
//        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+7:00")! as TimeZone
//        let stringDate = self.dateFormatter.string(from: Date())
//        countarr = [cellData(Topupno: "123456", Date: stringDate, AmountMoney: 50),cellData(Topupno: "123456", Date: stringDate, AmountMoney: 50)]
        
        
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
                    self.countarr += [cellData(Topupno: document.documentID, Date: stringDate, AmountMoney: document.data()["AmountMoney"] as! Int)]

                }
                print(self.countarr)
                self.tableTopup.reloadData()
                self.tableTopup.delegate = self
                self.tableTopup.dataSource = self
            }
            print("Out of Else \(self.countarr)")
        }
        print("Out of Database \(self.countarr)")
        
    
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        cell.Topupno.text = countarr[indexPath.row].Topupno
        cell.Date.text = countarr[indexPath.row].Date
        cell.AmountMoney.text = "+" + String(countarr[indexPath.row].AmountMoney) + "฿"
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return countarr.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
//        cell.Topupno.text = countarr[indexPath.row].Topupno
//        cell.Date.text = countarr[indexPath.row].Date
//        cell.AmountMoney.text = "\(countarr[indexPath.row].AmountMoney)"
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 80
//    }

    @IBAction func backBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    

}
