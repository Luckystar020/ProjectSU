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
    var WalletID : String = ""
    var Balance : Float = 0.0
    let picker = UIImagePickerController()
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
//        sideView.layer.shadowColor = UIColor.black.cgColor
//        sideView.layer.shadowOpacity = 0.8
//        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        if fieldNameLabel.text=="Name"&&fieldBalanceLabel.text=="Balance" {
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.color = UIColor.black
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
        }
        
        
        
        navigationController?.navigationBar.isHidden = false
        
        self.ProfileImage.layer.borderWidth = 2
        self.ProfileImage.layer.borderColor = UIColor.gray.cgColor
        self.ProfileImage.layer.masksToBounds = false
        self.ProfileImage.layer.cornerRadius = ProfileImage.frame.height/2
        self.ProfileImage.clipsToBounds = true
        
        let timestamp = NSDate()
        print("TimeStamp : \(timestamp)")
        
//        print(self.UID)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callData()
    }
    
    
    
    @IBAction func TopupBtn(_ sender: Any) {
        if self.WalletID == ""{
            return
        } else{
            let generateQR:GenerateQRController = self.storyboard!.instantiateViewController(withIdentifier: "GenerateQRController") as! GenerateQRController
            generateQR.WalletID = self.WalletID
            self.present(generateQR, animated: true, completion: nil)
            GenerateQRController().WalletID = self.WalletID
        }
        
    }
    
    @IBAction func rewardBTN(_ sender: Any) {
        let historyReward:HistoryRewardController = self.storyboard!.instantiateViewController(withIdentifier: "HistoryReward") as! HistoryRewardController
        
        self.present(historyReward, animated: true, completion: nil)
    }
    
    @IBAction func promoBTN(_ sender: Any) {
        let promotionPage:PromotionController = self.storyboard!.instantiateViewController(withIdentifier: "Promotion") as! PromotionController
        self.present(promotionPage, animated: true, completion: nil)
    }
    
    @IBAction func paymentHistoryBTN(_ sender: Any) {
        let historyPayment:HistoryPayment = self.storyboard!.instantiateViewController(withIdentifier: "HistoryPayment") as! HistoryPayment
        historyPayment.WID = self.WalletID
        self.present(historyPayment, animated: true, completion: nil)
    }
    
    @IBAction func topupHistoryBTN(_ sender: Any) {
        
        let topupPayment:HistoryTopupViewController = self.storyboard?.instantiateViewController(withIdentifier: "HistoryTopup") as! HistoryTopupViewController
        topupPayment.WID = self.WalletID
        self.present(topupPayment, animated: true, completion: nil)
    }
    
   
    //Get data from Display name and Balance
    func callData(){
        let data = db.collection("user").document(self.UID)
        let data2 = db.collection("wallet").whereField("UID", isEqualTo: self.UID)
        
        //Get data from collection user
        data.getDocument { (document, error) in
            if let document = document {
                self.fieldNameLabel.text = "Welcome : \(document.data()!["Fullname"] as? String ?? "")"
            }
        }
        
        //Get data from collection wallet
        data2.getDocuments { (snapshot, error) in
            if let error = error{
                print(error)
            } else{
                for document in (snapshot?.documents)!{
                self.fieldBalanceLabel.text = "Balance : \(document.data()["Price"] as? Float ?? 0)  ฿"
                self.WalletID = document.documentID
                    print(self.WalletID)
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
    }
    
    /*BTN Logged out*/
    @IBAction func logoutTapped(_ sender: Any) {
        let Alert = UIAlertController(title: "Log out", message: "Are you sure log out?", preferredStyle: UIAlertControllerStyle.alert)
        Alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        Alert.addAction(UIAlertAction(title: "Sure", style: UIAlertActionStyle.default, handler: { _ in
           self.log_out()
        }))
        self.present(Alert, animated: true, completion: nil)
    }
    /*****************/
    
    /*Function logged out from Firebase*/
    func log_out() {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            
        } catch{
            print("Have Problem!")
        }
    }
    
    /*Function change image profile*/
    @IBAction func imageChanged(_ sender: UIButton) {
        let Alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        Alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.getCamera()
        }))
        
        Alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.getLibrary()
        }))
        
        Alert.addAction(UIAlertAction(title: "Edit Profile", style: .default, handler: { _ in
            print("Edit Profile")
            self.editProfile()
        }))
        
        Alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(Alert, animated: true, completion: nil)
    }
    /*******BTN change profile******/
    
    /*Function option for change profile image*/
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
    func editProfile(){
        let profileController : ProfileController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        profileController.UID = self.UID
        self.present(profileController, animated: true, completion: nil)
    }
    /** END function option change profile**/
    
}

