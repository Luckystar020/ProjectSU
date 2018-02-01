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
import NVActivityIndicatorView

class MainPageController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var fieldBalanceLabel: UILabel!
    
    var db  = Firestore.firestore()
    var UID: String = ""
    var Fullname : String = ""
    var Balance : Float = 0.0
    
    let picker = UIImagePickerController()

    
    
    @IBAction func imageChanged(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.getCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.getLibrary()
        }))
        
        alert.addAction(UIAlertAction(title: "Edit Profile", style: .default, handler: {_ in
            print("Edit Profile")
        }))

        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCamera(){
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        present(picker, animated: true, completion: nil)

    }
    
    func getLibrary(){
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ProfileImage.image = chosenImage
        ProfileImage.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
//        sideView.layer.shadowColor = UIColor.black.cgColor
//        sideView.layer.shadowOpacity = 0.8
//        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        self.ProfileImage.layer.borderWidth = 2
        self.ProfileImage.layer.borderColor = UIColor.gray.cgColor
        self.ProfileImage.layer.masksToBounds = false
        self.ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
        self.ProfileImage.clipsToBounds = true
        
//        print(self.UID)
        callData()
    }
    
    @IBAction func promoBTN(_ sender: Any) {
        performSegue(withIdentifier: "promotionSegue", sender: self)
    }
    
    @IBAction func paymentHistoryBTN(_ sender: Any) {
        performSegue(withIdentifier: "openHisPayment", sender: self)
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
                    print("WID is in mainpage \(document.documentID)")
                }
            }
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

