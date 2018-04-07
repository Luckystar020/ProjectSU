//
//  ProfileController.swift
//  eWallet
//
//  Created by chain'rong KST on 5/2/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore


class ProfileController: UIViewController {
    
    var db = Firestore.firestore()

    var UserID : String = ""
    @IBOutlet weak var Fullname: UITextField!
    @IBOutlet weak var Birthdate: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var versionLabel: UILabel!
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var r = "Demo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = "Version \(r)"
        
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
        
        Fullname.inputAccessoryView = toolBar
        Birthdate.inputAccessoryView = toolbarPickdate
        //assigning date picker to text field
        Birthdate.inputView = datePicker
        Phone.inputAccessoryView = toolBar
        
        self.db.collection("Users").document(self.UserID).addSnapshotListener { (snapshot, err) in
            if let err = err{
                print(err.localizedDescription)
            }else{
                self.Fullname.text?.append(snapshot?.data()!["Fullname"] as! String)
                self.Birthdate.text?.append(snapshot?.data()!["Birthdate"] as! String)
                self.Phone.text?.append(snapshot?.data()!["Phone"] as! String)
                self.Email.text?.append(snapshot?.data()!["Email"] as! String)
                self.Email.isUserInteractionEnabled = false
            }
        }
        
    }
    
    @objc func donePickdate(){
        Birthdate.text = self.dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.title = "Edit Profile"
    }

    @IBAction func cancelBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveEdit(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure to edit profile?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            if let fullname = self.Fullname.text,let birthdate = self.Birthdate.text, let phone = self.Phone.text{
                self.db.collection("Users").document(self.UserID).updateData(["Fullname" : fullname,
                                                           "Birthdate" : birthdate,
                                                           "Phone" : phone])
            }
        }))
        
    }
    
    

}
