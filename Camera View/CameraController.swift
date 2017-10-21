//
//  ViewController.swift
//  Camera View
//
//  Created by Neil on 20/10/2017.
//  Copyright © 2017 Neil. All rights reserved.
//

import UIKit
import AVFoundation

var captureSession: AVCaptureSession?
var videoPreviewLayer: AVCaptureVideoPreviewLayer?
var capturePhotoOutput: AVCapturePhotoOutput?

class CameraController: UIViewController {

    @IBOutlet weak var previewLayer: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var takenImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        initiateCamera()
        styleCamera()
    }
    
    
    func initiateCamera(){
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
        }catch{
            print(error)
        }
        
        captureSession?.startRunning()
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        
        captureSession?.addOutput(capturePhotoOutput!)
    
    }
    
    @IBAction func onTapTakePhoto(_ sender: Any) {
        
        
        guard let capturePhotoOutput = capturePhotoOutput else {return}
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func styleCamera(){
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.frame
        previewLayer.layer.addSublayer(videoPreviewLayer!)
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 10
        cameraButton.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
    }
    
    func captureVideoOutput(){
        print("Video")
    }
    

}

extension CameraController : AVCapturePhotoCaptureDelegate{
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        
        guard error == nil, let _ = photoSampleBuffer else{
            print(error as Any)
            return
        }
        
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {return}
        
        let capturedImage = UIImage.init(data: imageData, scale: 2.0)
        if let image = capturedImage{
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            takenImageView.image = image
        }
        
    }
    
}

