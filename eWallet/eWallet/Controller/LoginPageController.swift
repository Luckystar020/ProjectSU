//
//  ViewController.swift
//  eWallet
//
//  Created by chain'rong KST on 26/11/2560 BE.
//  Copyright © 2560 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginPageController: UIViewController{
    
//    var db = Firestore.firestore()
    var UID : String = ""
    var SID : String = ""
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
            self.UID = (Auth.auth().currentUser?.uid)!
            self.whenLogin()
        }
    }
    
//    @IBAction func createAccount(_ sender: Any) {
//        self.performSegue(withIdentifier: "RegisterController", sender: nil)
//    }
    
    @IBAction func loginTapped(_ sender: Any) {
        if let email = emailTextFeild.text?.lowercased(), let password = passwordTextField.text{
            //Authen signIn with email
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if let firebaseError = error{print(firebaseError.localizedDescription)
                    //Check Error
                    return
                } else{
                    //Successful to Login
                    self.UID = (user?.uid)!
                    self.whenLogin()
                    print("Success!")
                }
            })
        }
    }
    
    func whenLogin(){
//        db.collection("user").document(self.UID).getDocument { (doc, err) in
//            if let err = err{
//                print(err.localizedDescription)
//            }else{
//                self.TypeUser = doc?.data()!["UserType"] as! Int
//            }
//        }
            let mainpageController:MainPageController = self.storyboard!.instantiateViewController(withIdentifier: "MainPageController") as! MainPageController
            mainpageController.UID = self.UID
            self.present(mainpageController, animated: true, completion: nil)
    }
}

