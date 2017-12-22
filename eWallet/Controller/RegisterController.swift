//
//  RegisterController.swift
//  eWallet
//
//  Created by chain'rong KST on 29/11/2560 BE.
//  Copyright © 2560 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth


class RegisterController: UIViewController {
    
    let db = Firestore.firestore()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    var UID : String = ""
    
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
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func toolbarCreate(){
        //format for picker
        datePicker.datePickerMode = .date
        // format date
        
        self.dateFormatter.dateStyle = .long
        self.dateFormatter.timeStyle = .none
        
        
        // toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let toolbarPickdate = UIToolbar()
        toolbarPickdate.sizeToFit()
        
        // bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneClicked))
        let donePickDate = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePickdate))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace , doneButton], animated: false)
        toolbarPickdate.setItems([flexibleSpace , donePickDate], animated: false)
        
        
        fullnameTextField.inputAccessoryView = toolBar
        birthdateTextField.inputAccessoryView = toolbarPickdate
        // assigning date picker to text field
        birthdateTextField.inputView = datePicker
        phoneTextField.inputAccessoryView = toolBar
        personidTextField.inputAccessoryView = toolBar
        emailTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        repasswordTextField.inputAccessoryView = toolBar
        ///////////////////////////
    }
    
    @objc func donePickdate(){
        birthdateTextField.text = self.dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    //Function Check validate email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func createWallet(UID:String,Name:String) {
        let Amount = 0.0
        let RewardPoint = 0
        self.db.collection("wallet").addDocument(data: [
            "Price":Amount,
            "RewardPoint":RewardPoint,
            "UID":UID
            ])
        
    }
    
    

    @IBAction func registerTapped(_ sender: Any) {
//        var ref: DocumentReference? = nil
       
        
        if let fullname = fullnameTextField.text , let birthdate = birthdateTextField.text , let phone = phoneTextField.text , let personal = personidTextField.text , let email = emailTextField.text , let password = passwordTextField.text , let repass = repasswordTextField.text{
            if self.isValidEmail(testStr: email) == true{
            if password == repass{
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user,error ) in
                if let firebaseError = error{
                    print(firebaseError.localizedDescription)
                    return
                }//if Error
                
                self.UID = user?.uid as! String
                
                    self.db.collection("user").document(self.UID).setData([
                    "Fullname" : fullname,
                    "Birthdate" : birthdate,
                    "Phone" : phone,
                    "Personal" : personal,
                    "Email" : email]) {(err) in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else{
//                        print("Document add with ID: \(self.UID)")
                        self.createWallet(UID: self.UID, Name: fullname)
                                }
                    }//END Push infomation to Clound Firestore
                
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if let firebaseError = error{print(firebaseError.localizedDescription)
                        //Check Error
                        return
                    }
                    self.gotoMainPage()
                    print("Success!")
                })
            })//END Register
                
               
//                navigationController?.popViewController(animated: true)
//                dismiss(animated: true, completion: nil)
                
            }//END Check password
        }//END Check func isValidEmail
                
                
            else{
                // create the alert
                let Alert = UIAlertController(title: "Something Wrong!", message: "Email is invalid!", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                Alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(Alert, animated: true, completion: nil)
            }//else Email invalid Alert
            
        }//END if let
       
    
    }//Button Register
    
    func gotoMainPage(){
        let mainpageController:MainPageController = self.storyboard!.instantiateViewController(withIdentifier: "MainPageController") as! MainPageController
        mainpageController.UID = self.UID
        self.present(mainpageController, animated: true, completion: nil)
        
    }

   
}