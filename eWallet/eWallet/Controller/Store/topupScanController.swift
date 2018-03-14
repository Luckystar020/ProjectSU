//
//  topupScanController.swift
//  eWallet
//
//  Created by Chai'nrong KST on 1/3/2561 BE.
//  Copyright © 2561 chain'rong KST. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore

class topupScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var square: UIView?
    @IBOutlet weak var qrCodeFrameView: UIView!
    var WalletID_User = ""
    var WalletID_Store = ""
    var captureSession = AVCaptureSession()
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deviceDiscoverySession = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: deviceDiscoverySession!)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
        } catch{
            
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        video = AVCaptureVideoPreviewLayer(session: captureSession)
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        video.frame = qrCodeFrameView.layer.bounds
        qrCodeFrameView.layer.addSublayer(video)
        
        square = UIView()
        
        if let square = square {
            square.layer.borderColor = UIColor.green.cgColor
            square.layer.borderWidth = 2
            qrCodeFrameView.addSubview(square)
            qrCodeFrameView.bringSubview(toFront: square)
        }
        
        //Start video capture.
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0{
            square?.frame = CGRect.zero
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr{
            let barcodeObject = video.transformedMetadataObject(for: metadataObj)
            square?.frame = (barcodeObject?.bounds)!
            
            if metadataObj.stringValue != nil{
                self.WalletID_User = metadataObj.stringValue!
                self.performSegue(withIdentifier: "sendPage2", sender: self)
                //                print("RRRRRRRRRRRRRRR \(self.WID)")
                captureSession.stopRunning()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendPage2"{
            let destination = segue.destination as! DetailTopupController
            destination.WalletID_User = self.WalletID_User
            destination.WalletID_Store = self.WalletID_Store
            print("Change page with data : \(destination.WalletID_User)")
        }
        
        
    }
    
}

