//
//  generateQRController.swift
//  eWallet
//
//  Created by chain'rong KST on 11/1/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

class GenerateQRController: UIViewController {

    @IBOutlet weak var generateBTN: UIButton!
    @IBOutlet weak var imgQRCode: UIImageView!
    
    var qrcodeImage : CIImage!
    let mainpageController = MainPageController()
    var db = Firestore.firestore()
    var WalletID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("\(self.WalletID) Woohoo!")
//        print("This UID is : \(self.UID)")
    }
   
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   //Generate QRCode and Change UIImage
    @IBAction func changeUIImage(_ sender: Any) {
        if qrcodeImage == nil {
            
            let data = self.WalletID.data(using: String.Encoding.utf8, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            qrcodeImage = filter?.outputImage
            
            print("Hi Girls! \(self.WalletID)" )
            if self.WalletID == ""{
                return
            }
        }
        
        imgQRCode.image = UIImage.init(ciImage: qrcodeImage)
        displayQRCodeImage()
    }
    
    // Fix Scale QRCode Equals UIImage
    func displayQRCodeImage() {
        
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imgQRCode.image = UIImage.init(ciImage: transformedImage)
        
        
    }
    
}
        

    
    

