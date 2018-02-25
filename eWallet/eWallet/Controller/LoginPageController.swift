//
//  ViewController.swift
//  eWallet
//
//  Created by chain'rong KST on 26/11/2560 BE.
//  Copyright © 2560 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginPageController: UIViewController{
    
//    let db = Firestore.firestore()
    var UserID : String = ""
    var StoreID : String = ""
    var TypeUser : Int = 0
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //hidden nav bar
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Condition Check was logged in auto to MainPage
        if Auth.auth().currentUser != nil {
            self.whenLogin(UserID: (Auth.auth().currentUser?.uid)!)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = emailTextFeild.text?.lowercased(), let password = passwordTextField.text{
            //Authen signIn with email
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let firebaseError = error{print(firebaseError.localizedDescription)
                    //Check Error
                    return
                } else{
                    //Successful to Login
                    self.whenLogin(UserID: (user?.uid)!)
                    print("Success!")
                }
            })
        }
    }
    
    func whenLogin(UserID : String){
        let db = Firestore.firestore()
        db.collection("Users").document(self.UserID).getDocument { (doc, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                self.TypeUser = doc?.data()!["UserType"] as! Int
                if self.TypeUser == 1{
                    let mainpageController:MainPageController = self.storyboard!.instantiateViewController(withIdentifier: "MainPageController") as! MainPageController
                    mainpageController.UID = self.UserID
                    self.present(mainpageController, animated: true, completion: nil)
                } else if self.TypeUser == 2{
                    let storeMain:StoreMainController = self.storyboard!.instantiateViewController(withIdentifier: "StoreMainController") as! StoreMainController
                    storeMain.UserID = self.UserID
                    self.present(storeMain, animated: true, completion: nil)
                }
            }
        }
//        let mainpageController:MainPageController = self.storyboard!.instantiateViewController(withIdentifier: "MainPageController") as! MainPageController
//        mainpageController.UID = UserID
//        self.present(mainpageController, animated: true, completion: nil)
        
    }
}

