//
//  StoreQRController.swift
//  eWallet
//
//  Created by Chai'nrong KST on 9/3/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import FirebaseFirestore

class StoreQRController: UIViewController {

    @IBOutlet weak var imgQRCode: UIImageView!
    
    var qrcodeImage : CIImage!
    let mainpageController = MainPageController()
    var db = Firestore.firestore()
    var WalletID_Store : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Generate QRCode and Change UIImage
        if qrcodeImage == nil {
            
            let data = self.WalletID_Store.data(using: String.Encoding.utf8, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            qrcodeImage = filter?.outputImage
            
            print("Hi Girls! \(self.WalletID_Store)" )
            if self.WalletID_Store == ""{
                return
            }
        }
        
        imgQRCode.image = UIImage.init(ciImage: qrcodeImage)
        displayQRCodeImage()
        
    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Fix Scale QRCode Equals UIImage
    func displayQRCodeImage() {
        
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imgQRCode.image = UIImage.init(ciImage: transformedImage)
        
        
    }
}
