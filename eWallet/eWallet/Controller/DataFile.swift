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
        
    }
    
    
    
  
    
}
