//
//  ViewController.swift
//  Lorem Ipsu
//
//  Created by Sherzod Makhmudov on 5/18/19.
//  Copyright © 2019 Sherzod Makhmudov All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire


class CameraViewController: UIViewController {

   var captureSession = AVCaptureSession()
   var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
    
    @IBOutlet weak var cameraView: UIView!
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice(){
       let deviceDiscovry = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        let devices = deviceDiscovry.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            }else  if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
            currentCamera = backCamera
        }
   
    }
    
    func setupInputOutput(){
        
        do{
               let captureDeviceInputs = try AVCaptureDeviceInput(device: currentCamera!)
                captureSession.addInput(captureDeviceInputs)
                photoOutput = AVCapturePhotoOutput()
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            
                captureSession.addOutput(photoOutput!)
        }catch{
            print("error")
        }
    
    }
    
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        cameraPreviewLayer?.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
        cameraPreviewLayer?.bounds = cameraView.frame
        cameraView.layer.addSublayer(cameraPreviewLayer!)
        
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
        
    }
    
    
 
    @IBAction func shutterBtnWasPressed(_ sender: UIButton) {
      
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self as! AVCapturePhotoCaptureDelegate)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPicture"{
            let previewVC = segue.destination as! visualRecognitionViewController
            previewVC.previewImage = self.image
            
        }
    }
    
}


extension CameraViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            
            image = UIImage(data: imageData)
        
            performSegue(withIdentifier: "showPicture", sender: nil)
        }
    }
    
}

