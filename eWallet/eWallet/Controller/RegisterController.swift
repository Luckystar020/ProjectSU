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
    
//    let db = Firestore.firestore()
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    let aDataFile = DataFile()
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
    
    

    @IBAction func registerTapped(_ sender: Any) {
//        var ref: DocumentReference? = nil
       
        
        if let fullname = fullnameTextField.text , let birthdate = birthdateTextField.text , let phone = phoneTextField.text , let personal = personidTextField.text , let email = emailTextField.text , let password = passwordTextField.text , let repass = repasswordTextField.text{

            if aDataFile.isValidEmail(testStr: email) == true{
            aDataFile.Register(name: fullname, birth: birthdate, phone: phone, personalID: personal, email: email, password: password, re_pass: repass, shop: "")
            } else{
                // create the alert
                let Alert = UIAlertController(title: "Something Wrong!", message: "Email is invalid!", preferredStyle: UIAlertControllerStyle.alert)

                Alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))

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
