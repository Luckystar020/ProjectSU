//
//  HistoryRewardController.swift
//  eWallet
//
//  Created by chain'rong KST on 17/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct dataReward {
    let rewardNo : String!
    let rewardDate : String!
    let rewardPoint : Int!
}

class HistoryRewardController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var UserType : Int!
    var arr = [dataReward]()
    var WalletID : String = ""
    var db = Firestore.firestore()
    @IBOutlet weak var tableReward: UITableView!
    let dateFormatter = DateFormatter()
    

    override func viewDidLoad() {
        
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+07:00")! as TimeZone
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let stringDate = self.dateFormatter.string(from: Date())
        
//        arr = [dataReward(rewardNo:"1234567890",rewardDate:stringDate as String,rewardPoint:10),dataReward(rewardNo:"9876533432",rewardDate:stringDate as String,rewardPoint:15),dataReward(rewardNo:"8765678933",rewardDate:stringDate,rewardPoint:0),dataReward(rewardNo:"25364759404",rewardDate:stringDate,rewardPoint:1)]
        
        db.collection("Wallet").document(self.WalletID).collection("HistoryReward").getDocuments { (snapshot, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                for document in (snapshot?.documents)!{
                    print(document.documentID )
                    print(document.data()["Reward"] as! Int)
                    print(document.data()["Date"] as! Date)
                    print(document.data()["RecieveFrom"] as! String)
                    //                    self.dateTopup.append(document.data()["DateTopup"] as Any)
                    self.dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+07:00")! as TimeZone
                    self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let stringDate = self.dateFormatter.string(from: document.data()["Date"] as! Date)
                    self.arr += [dataReward(rewardNo: document.documentID, rewardDate: stringDate, rewardPoint: document.data()["Reward"] as! Int)]

                }
                print(self.arr)
                self.tableReward.reloadData()
                self.tableReward.delegate = self
                self.tableReward.dataSource = self
            }
            print("Out of Else \(self.arr)")
        }
        print("Out of Database \(self.arr)")
        
        self.tableReward.reloadData()
        self.tableReward.delegate = self
        self.tableReward.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RewardViewCell", owner: self, options: nil)?.first as! RewardViewCell
        if UserType == 1{
            cell.rewardNo.text = arr[indexPath.row].rewardNo
            cell.rewardDate.text = arr[indexPath.row].rewardDate
            cell.RewardPoint.text = "+"+String(arr[indexPath.row].rewardPoint)+" P"
        } else if UserType == 2{
            cell.rewardNo.text = arr[indexPath.row].rewardNo
            cell.rewardDate.text = arr[indexPath.row].rewardDate
            cell.RewardPoint.text = ""+String(arr[indexPath.row].rewardPoint)+" P"
        }
        return cell
    }
    
    @IBAction func backBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
