//
//  RegisterShopController.swift
//  eWallet
//
//  Created by chain'rong KST on 21/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RegisterShopController: UIViewController {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var StoreID : String = ""
    var UserID : String = ""
    var WalletID : String = ""
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Birthdate: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var Fax: UITextField!
    @IBOutlet weak var PersonalID: UITextField!
    @IBOutlet weak var Account: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var StoreName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolbar()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        let navbar = self.navigationController?.navigationBar
        navbar?.isHidden = false
        navbar?.backgroundColor = UIColor.white
        navbar?.tintColor = UIColor.black
        navbar?.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
    }
    
    func toolbar(){
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
        
        Name.inputAccessoryView = toolBar
        Birthdate.inputAccessoryView = toolbarPickdate
        //assigning date picker to text field
        Birthdate.inputView = datePicker
        Phone.inputAccessoryView = toolBar
        Account.inputAccessoryView = toolBar
        Address.inputAccessoryView = toolBar
        Fax.inputAccessoryView = toolBar
        PersonalID.inputAccessoryView = toolBar
        StoreName.inputAccessoryView = toolBar
        Email.inputAccessoryView = toolBar
        Password.inputAccessoryView = toolBar
        ConfirmPassword.inputAccessoryView = toolBar
    }
    
    @objc func donePickdate(){
        Birthdate.text = self.dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    /***********Function Check validate email***********/
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }/**************************************************/
    
    
    /*Send page to Main*/
    func gotoMainPage(){
        let storeMain:StoreMainController = self.storyboard!.instantiateViewController(withIdentifier: "StoreMainController") as! StoreMainController
        storeMain.UserID = self.UserID
        self.present(storeMain, animated: true, completion: nil)
    }
    /******************/
    
    @IBAction func RegisterBTN(_ sender: Any) {
        if let Name = Name.text, let Birthdate = Birthdate.text, let Phone = Phone.text, let Fax = Fax.text, let PersonalID = PersonalID.text, let Account = Account.text, let Address = Address.text, let StoreName = StoreName.text, let Email = Email.text, let Password = Password.text, let ConfirmPassword = ConfirmPassword.text{
            if isValidEmail(testStr: Email) == true{
                if Password == ConfirmPassword{
                    auth.createUser(withEmail: Email, password: Password, completion: { (User, err) in
                        if let firebaseError = err{
                            print(firebaseError.localizedDescription)
                        }else{
                            self.UserID = (User?.uid)!
                            let addUser = self.db.collection("Users").document(self.UserID)
                            addUser.setData(["Fullname" : Name,
                                          "Birthdate" : Birthdate,
                                          "Phone" : Phone,
                                          "Personal" : PersonalID,
                                          "Email" : Email,
                                          "StoreID" : self.StoreID,
                                          "Usertype": 2]
                                    , completion: { (Error) in
                                        if let firestoreErr = Error{
                                            print(firestoreErr.localizedDescription)
                                        }else{
                                            print("Document add Store with ID: \(addUser.documentID)")
                                            let addStore = self.db.collection("Store").document()
                                            addStore.setData(
                                                ["StoreName" : StoreName,
                                                 "Address" : Address,
                                                 "Telephone": Phone,
                                                 "Fax": Fax,
                                                 "AccountNo": Account,
                                                 "CreateDate": NSDate(),
                                                 "UserID": self.UserID,
                                                 "Wallet": self.WalletID,
                                                 "StatusAccept": false]
                                                , completion: { (Error) in
                                                    if let firestoreErr = Error{
                                                        print(firestoreErr.localizedDescription)
                                                    }else{
                                                        print("Document add Store with ID: \(addStore.documentID)")
                                                        self.StoreID = addStore.documentID
                                                        let addWallet = self.db.collection("Wallet").document()
                                                        addWallet.setData([
                                                            "Price":0.0,
                                                            "RewardPoint":0,
                                                            "UserID":self.UserID,
                                                            "StoreID":self.StoreID]
                                                            , completion: { (Error) in
                                                                if let firestoreError = Error{
                                                                    print(firestoreError.localizedDescription)
                                                                }else{
                                                                    self.WalletID = addWallet.documentID
                                                                    addUser.updateData(["StoreID" : self.StoreID])
                                                                    addStore.updateData(["WalletID" : self.WalletID])
                                                                    let Alert = UIAlertController(title: "Successful", message: "Welcome \(Name) to eWallet service", preferredStyle: UIAlertControllerStyle.alert)
                                                                    Alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { _ in
                                                                        self.gotoMainPage()
                                                                    }))
                                                                    self.present(Alert, animated: true, completion: nil)
                                                                }
                                                        })//Add Wallet
                                                    }
                                            })//Add Store
                                        }
                            })//Add User
                        }
                    })// Create Authen User
                }//Confirm Password
            }//Validate Email
        }//If let
    }//Button Register
    
    
    
}
