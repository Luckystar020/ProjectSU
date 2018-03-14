//
//  DetailTopupController.swift
//  eWallet
//
//  Created by Chai'nrong KST on 8/3/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DetailTopupController: UIViewController {
    
    var WalletID_User : String = ""
    var WalletID_Store : String = ""
    var UserID : String = ""
    var DB = Firestore.firestore()
    private var tempMoney : Float = 0
    private var Name : String = ""
    @IBOutlet weak var fieldAmountMoney: UITextField!
    var topupMoney : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFireStore()
    }
    
    @IBAction func nextStep(_ sender: Any) {
        let action = UIAlertController(title: "Are You Sure", message: "You will topup in \(self.Name) wallet amount \((self.fieldAmountMoney.text! as NSString).floatValue)", preferredStyle: .alert)
        
        action.addAction(UIAlertAction(title: "cancle", style: .cancel, handler: nil))
        action.addAction(UIAlertAction(title: "confirm", style: .default, handler: { (nil) in
            self.setData(Money: (self.fieldAmountMoney.text! as NSString).floatValue, WalletID_User: self.WalletID_User, WalletID_Store: self.WalletID_Store)
            //            self.performSegue(withIdentifier: "successTop", sender: self)
            print("Topup Successful")
            self.fieldAmountMoney.text = ""
        }))
        present(action, animated: true, completion: nil)
    }
    
    func setData(Money:Float , WalletID_User:String, WalletID_Store:String) {
        //Update Balance in Wallet
        self.tempMoney = self.tempMoney + Money
        let update_user = DB.collection("Wallet").document(WalletID_User)
        let update_store = DB.collection("Wallet").document(WalletID_Store)
        update_user.updateData(["Price": self.tempMoney], completion: { (err) in
            if let err = err{
                print("Error updating document: \(err)")
            } else{
                print("Document successfully updated")
                //Set History in collection'wallet' when topup
                update_user.collection("HistoryTopup")
                    .addDocument(data: ["AmountMoney" : Money,
                                        "WalletID_Topup": WalletID_Store,
                                        "WalletID_Recieve": WalletID_User,
                                        "DateTopup": NSDate()]) { (Error) in
                                            let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            print("Something Wrong!")
                                            
                }
                update_store.collection("HistoryTopup")
                    .addDocument(data: ["AmountMoney" : Money,
                                        "WalletID_Topup": WalletID_Store,
                                        "WalletID_Recieve": WalletID_User,
                                        "DateTopup": NSDate()]) { (Error) in
                                            let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
                                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                            print("Something Wrong!")
                }
            }
            self.performSegue(withIdentifier: "BackStoreMainPage", sender: self)
        })
    }
    
    func getDataFireStore() {
        let dataWalletUser = DB.collection("Wallet").document(self.WalletID_User)
        //var UID : String = ""
        dataWalletUser.getDocument { (doc, err) in
            if let document = doc{
                print(document.data()!["Price"] as! Float)
                print(document.data()!["UserID"] as! String)
                self.tempMoney = document.data()!["Price"] as! Float
                let dataUser = self.DB.collection("Users").document(document.data()!["UserID"] as! String )
                dataUser.getDocument(completion: { (doc, err) in
                    if let doc = doc{
                        self.Name = doc.data()!["Fullname"] as! String!
                        
                    }
                })
            }
        }
        
        let dataWalletStore = DB.collection("Wallet").document(self.WalletID_Store)
        dataWalletStore.getDocument { (Doc, Err) in
            if let doc = Doc{
                self.UserID = doc.data()!["UserID"] as! String
            }
        }
        
        
        print("WID is \(WalletID_User)")
        print(self.Name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackStoreMainPage"{
            let storeMain = segue.destination as! StoreMainController
            storeMain.UserID = self.UserID
            storeMain.WalletID_Store = self.WalletID_Store
        }
        
        
    }
    
}
