//
//  StoreMainController.swift
//  eWallet
//
//  Created by chain'rong KST on 16/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class StoreMainController: UIViewController {
    
    let db = Firestore.firestore()
    var WalletID_Store = ""
    var UserID : String = ""
    var StoreID : String = ""
    var UserType :Int = 0
    var status :Bool = false
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var storeNameField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Store\(StoreID)")
        // Do any additional setup after loading the view.
        
        let wallet = db.collection("Wallet").whereField("UserID", isEqualTo: UserID)
        wallet.getDocuments { (query, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            for document in (query?.documents)!{
                self.WalletID_Store = document.documentID
            }
        }
        
        
        if storeNameField.text == "StoreName"{
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        print(WalletID_Store)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
//        self.Usertype = db.collection("Users").document(UserID).value(forKey: "Usertype") as! Int
        
        db.collection("Store").whereField("UserID", isEqualTo: UserID).getDocuments(completion: { (Query, Err) in
            if let Err = Err{
                print(Err.localizedDescription)
            }else{
                for document in (Query?.documents)!{
                    self.storeNameField.text = document.data()["StoreName"] as? String
                    self.status = (document.data()["StatusAccept"] as? Bool)!
                }
            }
        })
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topupScan"{
            let destination = segue.destination as! topupScanController
            destination.WalletID_Store = self.WalletID_Store
            print("Change page with data : \(destination.WalletID_Store)")
        }
    }
    
    @IBAction func scanClicked(_ sender: Any) {
         self.performSegue(withIdentifier: "topupScan", sender: self)
        
    }
    
    @IBAction func StoreQR(_ sender: Any) {
        if self.WalletID_Store == ""{
            return
        } else{
//                if status == true{
//                    let storeQR:StoreQRController = self.storyboard!.instantiateViewController(withIdentifier: "StoreQRController") as! StoreQRController
//                    storeQR.WalletID_Store = self.WalletID_Store
//                    self.present(storeQR, animated: true, completion: nil)
//                }else{
//                    let alert = UIAlertController(title: "Your're store account not approve.", message: "Please wait for accepted.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
            let storeQR:StoreQRController = self.storyboard!.instantiateViewController(withIdentifier: "StoreQRController") as! StoreQRController
            storeQR.WalletID_Store = self.WalletID_Store
            self.present(storeQR, animated: true, completion: nil)
        }
    }
    
    //HisReward Page
    @IBAction func rewardBTN(_ sender: Any) {
        let historyReward:HistoryRewardController = self.storyboard!.instantiateViewController(withIdentifier: "HistoryReward") as! HistoryRewardController
        historyReward.UserType = self.UserType
        historyReward.WalletID = self.WalletID_Store
        self.present(historyReward, animated: true, completion: nil)
    }
    //Promotion Page
    @IBAction func promoBTN(_ sender: Any) {
        let promotionPage:PromotionController = self.storyboard!.instantiateViewController(withIdentifier: "Promotion") as! PromotionController
        self.present(promotionPage, animated: true, completion: nil)
    }
    //HisPayment Page
    @IBAction func paymentHistoryBTN(_ sender: Any) {
        let historyPayment:HistoryPayment = self.storyboard!.instantiateViewController(withIdentifier: "HistoryPayment") as! HistoryPayment
        historyPayment.WalletID = self.WalletID_Store
        historyPayment.UserType = self.UserType
        self.present(historyPayment, animated: true, completion: nil)
    }
    //HisTopup Page
    @IBAction func topupHistoryBTN(_ sender: Any) {
        let topupPayment:HistoryTopupViewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryTopup") as! HistoryTopupViewController
        topupPayment.WalletID = self.WalletID_Store
        topupPayment.UserType = self.UserType
        self.present(topupPayment, animated: true, completion: nil)
    }
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        let Alert = UIAlertController(title: "Log out", message: "Are you sure log out?", preferredStyle: UIAlertControllerStyle.alert)
        Alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "Sure", style: UIAlertActionStyle.default, handler: { _ in
            self.log_out()
        }))
        self.present(Alert, animated: true, completion: nil)
    }
    
    @IBAction func menuBTN(_ sender: Any) {
        let Alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Detail Store", style: .default, handler: { _ in
           print("Detail Store")
        }))
        
        Alert.addAction(UIAlertAction(title: "Site Store", style: .default, handler: { _ in
            print("Site Store")
        }))
        
//        Alert.addAction(UIAlertAction(title: "Edit Profile", style: .default, handler: { _ in
//            print("Edit Profile")
//
//        }))
        Alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(Alert, animated: true, completion: nil)
    }
    
    func log_out() {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch{
            print("Have Problem!")
        }
    }
    
}
