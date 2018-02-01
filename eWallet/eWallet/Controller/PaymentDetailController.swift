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
    
    var WID : String = ""
    var db = Firestore.firestore()
    private var tempMoney : Float = 0
    private var Name : String = ""
    @IBOutlet weak var fieldAmountMoney: UITextField!
    var topupMoney : Float = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getDataFireStore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    @IBAction func nextStep(_ sender: Any) {
       
        let action = UIAlertController(title: "Are You Sure", message: "You will topup in \(self.Name) wallet amount \((self.fieldAmountMoney.text! as NSString).floatValue)", preferredStyle: .alert)
        
        action.addAction(UIAlertAction(title: "cancle", style: .cancel, handler: nil))
        action.addAction(UIAlertAction(title: "confirm", style: .default, handler: { (nil) in
            self.setData(money: (self.fieldAmountMoney.text! as NSString).floatValue, wid: self.WID)
//            self.performSegue(withIdentifier: "successTop", sender: self)
            print("Topup Successful")
            self.fieldAmountMoney.text = ""
            
            
        }))
       
        present(action, animated: true, completion: nil)
    
    }
    
 
    
    func setData(money:Float , wid:String) {
        //Update Balance in wallet
        self.tempMoney = self.tempMoney + money
        let update = db.collection("wallet").document(wid)
        update.updateData(["Price": self.tempMoney], completion: { (err) in
            if let err = err{
                print("Error updating document: \(err)")
            } else{
                print("Document successfully updated")
            }
        })
        
        //Set History in collection'wallet' when topup
        let set = db.collection("wallet").document(wid).collection("HistoryTopup")
        set.addDocument(data: ["AmountMoney" : money,
                               "WID": wid,
                               "DateTopup": NSDate()]) { (Error) in
                                let alert = UIAlertController(title: "Error!", message: "Cannot set data history!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                print("Something Wrong!")
        }
        
        
    }
   

    func getDataFireStore() {
   
        let dataWallet = db.collection("wallet").document(self.WID)
//        var UID : String = ""
        dataWallet.getDocument { (doc, err) in
            if let document = doc{
                print(document.data()["Price"] as! Float)
                print(document.data()["UID"] as! String)
                self.tempMoney = document.data()["Price"] as! Float
                let dataUser = self.db.collection("user").document(document.data()["UID"] as! String )
                dataUser.getDocument(completion: { (doc, err) in
                    if let doc = doc{
                        self.Name = doc.data()["Fullname"] as! String!
                    }
                })
            }
        }
        print("WID is \(WID)")
        print(self.Name)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "topupSuccess"{
//
//        }
//    }
  
}
