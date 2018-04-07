//
//  PaymentDetailController.swift
//  eWallet
//
//  Created by chain'rong KST on 18/1/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

class PaymentDetailController: UIViewController {
    
    var WalletID_Store : String = ""
    var WalletID_User : String = ""
    var UserID : String = ""
    var db = Firestore.firestore()
    private var tempMoney_S : Float = 0
    private var tempMoney_U : Float = 0
    private var Name : String = ""
    var rewardPoint : Int = 0
    @IBOutlet weak var fieldAmountReward: UITextField!
    @IBOutlet weak var fieldAmountMoney: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getDataFireStore()
    }
    
    @IBAction func nextStep(_ sender: Any) {
        let action = UIAlertController(title: "Are You Sure", message: "You will pay in \(self.Name) wallet amount \((self.fieldAmountMoney.text! as NSString).floatValue)", preferredStyle: .alert)
        
        action.addAction(UIAlertAction(title: "cancle", style: .cancel, handler: nil))
        action.addAction(UIAlertAction(title: "confirm", style: .default, handler: { (nil) in
            
            self.setData(Money: (self.fieldAmountMoney.text! as NSString).floatValue, WalletID_Store: self.WalletID_Store,WalletID_User: self.WalletID_User, Reward: (self.fieldAmountReward.text! as NSString).integerValue)
            
//            self.performSegue(withIdentifier: "successTop", sender: self)
            print("Topup Successful")
            self.fieldAmountMoney.text = ""
            
        }))
       
        present(action, animated: true, completion: nil)
    
    }
    
    func random(_ n: Int) -> String
    {
        let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        
        var s = ""
        
        for _ in 0..<n
        {
            let r = Int(arc4random_uniform(UInt32(a.characters.count)))
            
            s += String(a[a.index(a.startIndex, offsetBy: r)])
        }
        
        return s
    }
    
 
    
    func setData(Money:Float , WalletID_Store:String, WalletID_User:String, Reward:Int) {
        //Update Balance in wallet
        if Money <= self.tempMoney_U{
        self.tempMoney_S = self.tempMoney_S + Money
        self.tempMoney_U = self.tempMoney_U - Money
        let update_Store = db.collection("Wallet").document(WalletID_Store)
        update_Store.updateData(["Price": self.tempMoney_S], completion: { (err) in
            if let err = err{
                print("Error updating document: \(err)")
            } else{
                print("Document Store successfully updated")
            }
        })
        
        let update_User = db.collection("Wallet").document(WalletID_User)
        update_User.updateData(["Price" : self.tempMoney_U], completion: { (err) in
            if let err = err{
                print("Error updating document: \(err)")
            } else{
                print("Document User successfully updated")
            }
        })
        
        if Money>=100{
            let reward : Int
                reward = self.rewardPoint + Int(Money/100)
            let addReward = db.collection("Wallet").document(WalletID_User)
            addReward.updateData(["RewardPoint" : reward], completion: { (Err) in
                if let err = Err{
                    print(err.localizedDescription)
                }
            })
            addReward.collection("HistoryReward").addDocument(data: ["Reward" : Int(Money/100),
                                                                     "Date" : NSDate(),
                                                                     "RecieveFrom" : WalletID_Store])
            let tranReward = db.collection("Wallet").document(WalletID_Store)
            tranReward.collection("HistoryReward").addDocument(data: ["Reward" : Int(Money/100),
                                                                      "Date" : NSDate(),
                                                                      "GiveTo" : WalletID_User])
        }
            let random_id = self.random(15)
        
        //Set History in collection'wallet' when topup
        let set_store = db.collection("Wallet").document(WalletID_Store).collection("HistoryPayment").document(random_id)
            set_store.setData(["AmountMoney" : Money,
                               "WalletID_U" : WalletID_User,
                               "WalletID_S" : WalletID_Store,
                               "DateTopup" : NSDate()]){ (Error) in
                                let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                print("Something Wrong!")
                                
            }
//        set_store.addDocument(data: ["AmountMoney" : Money,
//                                     "WalletID_U" : WalletID_User,
//                               "WalletID_S": WalletID_Store,
//                               "DateTopup": NSDate()]) { (Error) in
//                                let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
//                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                                print("Something Wrong!")
//        }
        let set_user = db.collection("Wallet").document(WalletID_User).collection("HistoryPayment").document(random_id)
            set_user.setData(["AmountMoney" : Money,
                              "WalletID_U" : WalletID_User,
                              "WalletID_S": WalletID_Store,
                              "DateTopup": NSDate()]) { (Error) in
                                let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                print("Something Wrong!")
            }
//        set_user.addDocument(data: ["AmountMoney" : Money,
//                                    "WalletID_U" : WalletID_User,
//                                    "WalletID_S": WalletID_Store,
//                                    "DateTopup": NSDate()]) { (Error) in
//                                        let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
//                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                                        print("Something Wrong!")
//        }
        self.performSegue(withIdentifier: "BackMainPage", sender: self)
        } else if Reward <= self.rewardPoint && Money <= self.tempMoney_U{
            //If Pay Money and Reward
            self.rewardPoint = self.rewardPoint - Reward
            self.tempMoney_S = self.tempMoney_S + Money
            self.tempMoney_U = self.tempMoney_U - Money
            let update_Store = db.collection("Wallet").document(WalletID_Store)
            update_Store.updateData(["Price": self.tempMoney_S], completion: { (err) in
                if let err = err{
                    print("Error updating document: \(err)")
                } else{
                    print("Document Store successfully updated")
                }
            })
            
            let update_User = db.collection("Wallet").document(WalletID_User)
            update_User.updateData(["Price" : self.tempMoney_U,
                                    "Reward" : self.rewardPoint], completion: { (err) in
                if let err = err{
                    print("Error updating document: \(err)")
                } else{
                    print("Document User successfully updated")
                }
            })
            
            if Money>=100{
                let reward : Int
                reward = self.rewardPoint + Int(Money/100)
                let addReward = db.collection("Wallet").document(WalletID_User)
                addReward.updateData(["RewardPoint" : reward], completion: { (Err) in
                    if let err = Err{
                        print(err.localizedDescription)
                    }
                })
                addReward.collection("HistoryReward").addDocument(data: ["Reward" : Int(Money/100),
                                                                         "Date" : NSDate(),
                                                                         "RecieveFrom" : WalletID_Store])
                let tranReward = db.collection("Wallet").document(WalletID_Store)
                tranReward.collection("HistoryReward").addDocument(data: ["Reward" : Int(Money/100),
                                                                          "Date" : NSDate(),
                                                                          "GiveTo" : WalletID_User])
            }
            
            //Set History in collection'wallet' when topup
            let set_store = db.collection("Wallet").document(WalletID_Store).collection("HistoryPayment")
            set_store.addDocument(data: ["AmountMoney" : Money,
                                         "WalletID_U": WalletID_User,
                                         "WalletID_S": WalletID_Store,
                                         "DateTopup": NSDate()]) { (Error) in
                                            let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            print("Something Wrong!")
            }
            let set_user = db.collection("Wallet").document(WalletID_User).collection("HistoryPayment")
            set_user.addDocument(data: ["AmountMoney" : Money,
                                        "WalletID_U": WalletID_User,
                                        "WalletID_S": WalletID_Store,
                                        "DateTopup": NSDate()]) { (Error) in
                                            let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            print("Something Wrong!")
            }
            self.performSegue(withIdentifier: "BackMainPage", sender: self)
            
        } else{
            let alert = UIAlertController(title: "Warning!", message: "Money or reward in wallet not enough!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "BackMainPage", sender: self)
            }))
        }
    }
   
    

    func getDataFireStore() {
        let dataWallet = db.collection("Wallet").document(self.WalletID_Store)
//        var UID : String = ""
        dataWallet.getDocument { (doc, err) in
            if let document = doc{
                print(document.data()!["Price"] as! Float)
                print(document.data()!["UserID"] as! String)
                self.tempMoney_S = document.data()!["Price"] as! Float
                let dataUser = self.db.collection("Users").document(document.data()!["UserID"] as! String )
                dataUser.getDocument(completion: { (doc, err) in
                    if let doc = doc{
                        self.Name = doc.data()!["Fullname"] as! String!
                    }
                })
            }
        }
        db.collection("Wallet").document(self.WalletID_User).getDocument { (Doc, Err) in
            if let err = Err{
                print(err.localizedDescription)
            }else{
                self.tempMoney_U = Doc?.data()!["Price"] as! Float
                self.UserID = Doc?.data()!["UserID"] as! String
                self.rewardPoint = Doc?.data()!["RewardPoint"] as! Int
            }
        }
        print("WID is \(WalletID_Store)")
        print(self.Name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackMainPage"{
             let main = segue.destination as! MainPageController
            main.WalletID_User = self.WalletID_User
            main.UserID = self.UserID
        }
    }
  
}
