//
//  LiveImageViewController.swift
//  ch08-cameraCoreML
//
//  Created by JeongHyeon Lee on 2021/04/14.
//

import UIKit
import AVKit

class LiveImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var captureSession: AVCaptureSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        guard let videoInput = createVideoInput() else {
            return
        }
        captureSession.addInput(videoInput)
        
        guard let videoOutput = createVideoOutput() else {
            return
        }
        captureSession.addOutput(videoOutput)
        // attachPreviewer(captureSession: captureSession)
        
        captureSession.commitConfiguration()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(takePicture))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        messageLabel.layer.borderWidth = 2
        messageLabel.layer.borderColor = UIColor.red.cgColor
    }
}

extension LiveImageViewController {
    @objc func takePicture(sender: UITapGestureRecognizer) {
        if captureSession.isRunning {
            captureSession.stopRunning()
        } else {
            captureSession.startRunning()
        }
    }
}

extension LiveImageViewController {
    func createVideoInput() -> AVCaptureDeviceInput? {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return nil
        }
        return try? AVCaptureDeviceInput(device: device)
    }
}

extension LiveImageViewController {
    func createVideoOutput() -> AVCaptureVideoDataOutput? {
        let videoOutput = AVCaptureVideoDataOutput()
        
        let settings: [String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]
        
        videoOutput.videoSettings = settings
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global())
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        return videoOutput
    }
}

extension LiveImageViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("sss")
        let x = CMSampleBufferGetImageBuffer(sampleBuffer)
        let y = CIImage(cvImageBuffer: x!)
        
        DispatchQueue.main.async {
            self.imageView.image = UIImage(ciImage: y)
        }
    }
}

extension LiveImageViewController {
    func attachPreviewer(captureSession: AVCaptureSession) {
        let avCaptureVideoPreviewer = AVCaptureVideoPreviewLayer(session: captureSession)
        avCaptureVideoPreviewer.frame = imageView.layer.bounds
        avCaptureVideoPreviewer.videoGravity = .resize
        imageView.layer.addSublayer(avCaptureVideoPreviewer)
    }
}
