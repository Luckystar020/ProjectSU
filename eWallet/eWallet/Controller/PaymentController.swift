//
//  PaymentController.swift
//  eWallet
//
//  Created by chain'rong KST on 13/1/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore

class PaymentController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    @IBOutlet weak var qrCodeFrameView: UIView!
    var stringURL:String = ""
    
    enum error: Error {
        case noCameraAvailable
        case videoInputInitFail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        do{
            try scanQRCode()
            print("TRY SCANNER")
            
            if stringURL != ""{
            let paymentdetailController: PaymentDetailController = self.storyboard!.instantiateViewController(withIdentifier: "PaymentDetailController") as! PaymentDetailController
                self.present(paymentdetailController, animated: true, completion: nil)
            }
            
        } catch{
          print("Failed to scan the QR/Barcode.")
        }
       
    }
    
    @IBAction func nonScan(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutputMetadataObjects metadataObjects:[Any]!, from connection: AVCaptureConnection!){
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr{
                stringURL = machineReadableCode.stringValue!
                performSegue(withIdentifier: "sendPage", sender: self)
            }
        }
    }
    
    func scanQRCode() throws{
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else{
            print("No camera!")
            throw error.noCameraAvailable
            
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Failed to init camera.")
            throw error.videoInputInitFail
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = qrCodeFrameView.bounds
        self.qrCodeFrameView.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        avCaptureSession.startRunning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendPage"{
            let destination = segue.destination as! PaymentDetailController
            destination.WID = stringURL
            
//            print(stringURL)
            
            
        }
    }
    
}
   

