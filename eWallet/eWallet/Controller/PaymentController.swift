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
    
    var square: UIView?
    @IBOutlet weak var qrCodeFrameView: UIView!
    var WID = ""
    var captureSession = AVCaptureSession()
    var video = AVCaptureVideoPreviewLayer()
    @IBAction func cancleBTN(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.default(for: AVMediaType.video)
        
//        guard let captureDevice = deviceDiscoverySession. else {
//            print("Failed to get the camera device")
//            return
//        }
        
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
                self.WID = metadataObj.stringValue!
                self.performSegue(withIdentifier: "sendPage", sender: self)
//                print("RRRRRRRRRRRRRRR \(self.WID)")
                captureSession.stopRunning()
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendPage"{
            let destination = segue.destination as! PaymentDetailController
            destination.WID = self.WID
            print("Change page with data : \(destination.WID)")
        }
    }
    
    
    
    ///Version1
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let session = AVCaptureSession()
//
//        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
//
//        do{
//            let input = try AVCaptureDeviceInput(device: captureDevice!)
//            session.addInput(input)
//        } catch{
//                print("ERROR")
//        }
//
//        let output = AVCaptureMetadataOutput()
//        session.addOutput(output)
//
//
//        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//
//        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//
//        video = AVCaptureVideoPreviewLayer(session: session)
//        video.frame = qrCodeFrameView.layer.bounds
//        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        qrCodeFrameView.layer.addSublayer(video)
//
//        session.startRunning()
//
//    }
//
//
//    func captureOutput(_ captureOutput: AVCaptureMetadataOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//        if metadataObjects != nil && metadataObjects.count != 0 {
//            print("Step1")
//            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
//                print("Step2")
//                if object.type == AVMetadataObject.ObjectType.qr{
//                    print("Step3")
//                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
//                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
//                        UIPasteboard.general.string = object.stringValue
//                    }))
//
//                    present(alert, animated: true, completion: nil)
//                }
//            }
//        }
//    }
    
///Version 2
    
//    @IBOutlet weak var qrCodeFrameView: UIView!
//    var stringURL:String = ""
//
//    enum error: Error {
//        case noCameraAvailable
//        case videoInputInitFail
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        do{
//            try scanQRCode()
//            print("TRY SCANNER")
//
//            if stringURL != ""{
//            let paymentdetailController: PaymentDetailController = self.storyboard!.instantiateViewController(withIdentifier: "PaymentDetailController") as! PaymentDetailController
//                self.present(paymentdetailController, animated: true, completion: nil)
//            }
//
//        } catch{
//          print("Failed to scan the QR/Barcode.")
//        }
//
//    }
//
//    @IBAction func nonScan(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func captureOutput(_ captureOutput: AVCaptureOutput, didOutputMetadataObjects metadataObjects:[Any]!, from connection: AVCaptureConnection!){
//        if metadataObjects.count > 0 {
//            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//            if machineReadableCode.type == AVMetadataObject.ObjectType.qr{
//                stringURL = machineReadableCode.stringValue!
//                performSegue(withIdentifier: "sendPage", sender: self)
//            }
//        }
//    }
//
//    func scanQRCode() throws{
//        let avCaptureSession = AVCaptureSession()
//
//        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else{
//            print("No camera!")
//            throw error.noCameraAvailable
//
//        }
//
//        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
//            print("Failed to init camera.")
//            throw error.videoInputInitFail
//        }
//
//        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
//        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//
//        avCaptureSession.addInput(avCaptureInput)
//        avCaptureSession.addOutput(avCaptureMetadataOutput)
//
//        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//
//        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
//        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        avCaptureVideoPreviewLayer.frame = qrCodeFrameView.bounds
//        self.qrCodeFrameView.layer.addSublayer(avCaptureVideoPreviewLayer)
//
//        avCaptureSession.startRunning()
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sendPage"{
//            let destination = segue.destination as! PaymentDetailController
//            destination.WID = stringURL
//
////            print(stringURL)
//
//
//        }
//    }
    
}
   

