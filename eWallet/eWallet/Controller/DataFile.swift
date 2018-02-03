//
//  DataFile.swift
//  eWallet
//
//  Created by chain'rong KST on 1/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation
class DataFile{
    
    //Reference another class
    private let aMainpagecontroller : MainPageController? = MainPageController()
    private let aRegistercontroller : RegisterController? = RegisterController()
    private let aGenerateQr : GenerateQRController? = GenerateQRController()
    private let aPaymentController : PaymentController? = PaymentController()
    private let aPaymentDetailCon : PaymentDetailController? = PaymentDetailController()
    private let aPromotion : PromotionController? = PromotionController()
    private let aHistoryP : HistoryPayment? = HistoryPayment()
    
    //Reference Firebase
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    
    //Data ref.
    private var UID:String = ""
    
    /*Register Zone*/
    //Register
    public func Register(name:String, birth:String, phone:String, personalID: String, email:String, password:String, re_pass:String, shop:String){
        
        if self.isValidEmail(testStr: email) == true {
            if password == re_pass{
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user,err) in
                    if let firebaseError = err{
                        print(firebaseError.localizedDescription)
                        return
                    }
                    self.UID = (user?.uid)!
                    self.db.collection("user").document(self.UID).setData(["Fullname" : name,
                                                                           "Birthdate" : birth,
                                                                           "Phone" : phone,
                                                                           "Personal" : personalID,
                                                                           "Email" : email,
                                                                           "ShopID" : shop], completion: { (err) in
                                                                            //Have some problem
                                                                            if let err = err {
                                                                                print("Error adding data in document: \(err)")
                                                                            } else{
                                                                                print("Document add with ID: \(self.UID)")
                                                                                self.createWallet(uid: self.UID, name: name, Amount: 0, RewardPoint: 0, ShopID: "")
                                                                            }//Data added
                                                                            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
                                                                                if let firebaseError = err{
                                                                                    print(firebaseError.localizedDescription)
                                                                                    return
                                                                                } else{
                                                                                   
                                                                                }
                                                                            })
                    })//Auto login when success register
                    
                })//End register
            } else{
             print("Password and repass is not equal!")
            }//Password checked
        }//isValidEmail
    }
    
    //Create wallet
    public func createWallet(uid: String,name: String, Amount: Float, RewardPoint: Float, ShopID: String){
        self.db.collection("wallet").addDocument(data: [
            "Price":Amount,
            "RewardPoint":RewardPoint,
            "UID":uid,
            "SID":ShopID
            ])
    }
    
    //Function Check validate email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
