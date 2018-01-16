//
//  LoggedInPage.swift
//  eWallet
//
//  Created by chain'rong KST on 26/11/2560 BE.
//  Copyright © 2560 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainPageController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var fieldBalanceLabel: UILabel!
    
    var ImagePicker: UIImagePickerController!
    var db  = Firestore.firestore()
    var UID: String = ""
    var Fullname : String = ""
    var Balance : Float = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ProfileImage.layer.borderWidth = 2
        self.ProfileImage.layer.borderColor = UIColor.gray.cgColor
        self.ProfileImage.layer.masksToBounds = false
        self.ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
        self.ProfileImage.clipsToBounds = true
        
        
//        print(self.UID)
        callData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //Get data from Display name and Balance
    func callData(){
        let data = db.collection("user").document(self.UID)
        let data2 = db.collection("wallet").whereField("UID", isEqualTo: self.UID)
        
       
        data.getDocument { (document, error) in
            if let document = document {
               self.fieldNameLabel.text = "Welcome : \(document.data()["Fullname"] as? String ?? "")"
            }
        }
        
         
        data2.getDocuments { (snapshot, error) in
            if let error = error{
                print(error)
            } else{
                for document in (snapshot?.documents)!{
                self.fieldBalanceLabel.text = "Balance : \(document.data()["Price"] as? Float ?? 0)  ฿"
                }
            }
        }
        
    }
        
    
    
    @IBAction func changeImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
        }
        
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        do{
           try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            
        } catch{
            print("Have Problem!")
        }
    }
    
}

