//
//  RegisterController.swift
//  eWallet
//
//  Created by chain'rong KST on 29/11/2560 BE.
//  Copyright © 2560 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class RegisterController: UIViewController {
    
    let db = Firestore.firestore()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var UserID : String = ""
    var StoreID : String = ""
    
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var personidTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolbarCreate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navbar = self.navigationController?.navigationBar
        navbar?.isHidden = false
        navbar?.backgroundColor = UIColor.black
        navbar?.tintColor = UIColor.black
        navbar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
    }
    
    func toolbarCreate(){
        //format for picker
        datePicker.datePickerMode = .date
        // format date
        self.dateFormatter.dateStyle = .long
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+7:00")! as TimeZone
        self.dateFormatter.timeStyle = .none
        
        /*toolbar*/
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolbarPickdate = UIToolbar()
        toolbarPickdate.sizeToFit()
        /*********/
        
        /*Bar button item*/
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneClicked))
        let donePickDate = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePickdate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace , doneButton], animated: false)
        toolbarPickdate.setItems([flexibleSpace , donePickDate], animated: false)
        /*****************/
        
        fullnameTextField.inputAccessoryView = toolBar
        birthdateTextField.inputAccessoryView = toolbarPickdate
        //assigning date picker to text field
        birthdateTextField.inputView = datePicker
        phoneTextField.inputAccessoryView = toolBar
        personidTextField.inputAccessoryView = toolBar
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        repasswordTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePickdate(){
        birthdateTextField.text = self.dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    

    @IBAction func registerTapped(_ sender: Any) {
//        var ref: DocumentReference? = nil
        if let fullname = fullnameTextField.text, let birthdate = birthdateTextField.text, let phone = phoneTextField.text, let personal = personidTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let repass = repasswordTextField.text{
            
            if self.isValidEmail(testStr: email) == true {
                if password == repass{
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user,err) in
                        if let firebaseError = err{
                            print(firebaseError.localizedDescription)
                            return
                        }
                        self.UserID = (user?.uid)!
                        self.db.collection("Users")
                            .document(self.UserID)
                            .setData(["Fullname" : fullname,
                                      "Birthdate" : birthdate,
                                      "Phone" : phone,
                                      "Personal" : personal,
                                      "Email" : email,
                                      "StoreID" : self.StoreID,
                                      "Usertype": 1],
                                     completion: { (err) in
                                        //Have some problem
                                        if let err = err {
                                            print("Error adding data in document: \(err)")
                                        } else{
                                            print("Document add with ID: \(self.UserID)")
                                            self.createWallet(uid: self.UserID, name: fullname, Amount: 0, RewardPoint: 0, StoreID: self.StoreID)
                                        }//Data added
                                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
                                            if let firebaseError = err{
                                                print(firebaseError.localizedDescription)
                                                return
                                            } else{
                                                let Alert = UIAlertController(title: "Successful", message: "Welcome \(fullname) to eWallet service", preferredStyle: UIAlertControllerStyle.alert)
                                                Alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { _ in
                                                    self.gotoMainPage()
                                                }))
                                                self.present(Alert, animated: true, completion: nil)
                                            }
                                        })//Authentication in Firebase when created user
                            })//Auto login when success register
                    })//End register
                } else{
                    print("Password and repass is not correct!")
                }
            } else{
                // create the alert
                let Alert = UIAlertController(title: "Something Wrong!", message: "Email is invalid!", preferredStyle: UIAlertControllerStyle.alert)
                Alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(Alert, animated: true, completion: nil)
            }//else Email invalid Alert
        }//END if let
    }//Button Register
    
    
    /***********Function Check validate email***********/
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }/**************************************************/
    
    
    /***********Create wallet***********/
    public func createWallet(uid: String,name: String, Amount: Float, RewardPoint: Int, StoreID: String){
        self.db.collection("Wallet").addDocument(data: [
            "Price":Amount,
            "RewardPoint":RewardPoint,
            "UserID":uid,
            "StoreID":StoreID
            ])
    }/*********************************/
    
    /*Send page to Main*/
    func gotoMainPage(){
        let mainpageController:MainPageController = self.storyboard!.instantiateViewController(withIdentifier: "MainPageController") as! MainPageController
        mainpageController.UserID = self.UserID
        self.present(mainpageController, animated: true, completion: nil)
    }
    /******************/
   
}
