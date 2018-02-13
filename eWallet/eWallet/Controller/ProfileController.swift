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

    var UID : String = ""
    @IBOutlet weak var Fullname: UITextField!
    @IBOutlet weak var Birthdate: UITextField!
    @IBOutlet weak var Phone: UITextField!
    @IBOutlet weak var versionLabel: UILabel!
    var r = "0.1.3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        versionLabel.text = "Version \(r)"
        // Do any additional setup after loading the view.
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
                self.db.collection("user").document(self.UID).updateData(["Fullname" : fullname,
                                                           "Birthdate" : birthdate,
                                                           "Phone" : phone])
            }
        }))
        
    }
    
    

}
