//
//  LiveImageViewController.swift
//  ch08-cameraCoreML
//
//  Created by JeongHyeon Lee on 2021/04/14.
//

import UIKit
import AVKit
import Vision
import CoreML

class LiveImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var detectionOverlay: CALayer!
    var videoBufferSize = CGSize.zero
    
    var captureSession: AVCaptureSession!
    var request: VNCoreMLRequest!
    
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
        attachPreviewer(captureSession: captureSession)
        
        captureSession.commitConfiguration()
        request = createCoreML(modelName: "YOLOv3", modelExt: "mlmodelc", completionHandler: handleObjectDetection)

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
        do {
            try device.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((device.activeFormat.formatDescription))
            videoBufferSize.width = CGFloat(dimensions.width)
            videoBufferSize.height = CGFloat(dimensions.height)
            device.unlockForConfiguration()
        } catch {
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
//        let x = CMSampleBufferGetImageBuffer(sampleBuffer)
//        let y = CIImage(cvImageBuffer: x!)
//
//        DispatchQueue.main.async {
//            self.imageView.image = UIImage(ciImage: y)
//        }
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer!, orientation: .up, options: [:])
        try! imageRequestHandler.perform([request])
    }
}

extension LiveImageViewController {
    func attachPreviewer(captureSession: AVCaptureSession) {
        let avCaptureVideoPreviewer = AVCaptureVideoPreviewLayer(session: captureSession)
        avCaptureVideoPreviewer.frame = imageView.layer.bounds
        avCaptureVideoPreviewer.videoGravity = .resize
        imageView.layer.addSublayer(avCaptureVideoPreviewer)
        
        detectionOverlay = CALayer()    // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0, y: 0, width: videoBufferSize.width, height: videoBufferSize.height)
        detectionOverlay.position = CGPoint(x: detectionOverlay.bounds.midX, y: detectionOverlay.bounds.midY)
        avCaptureVideoPreviewer.addSublayer(detectionOverlay)
    }
}

extension LiveImageViewController {
    func createCoreML(modelName: String, modelExt: String, completionHandler: @escaping (VNRequest, Error?) -> Void) -> VNCoreMLRequest? {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: modelExt) else {
            return nil
        }
        guard let vnCoreMLModel = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else {
            return nil
        }
        return VNCoreMLRequest(model: vnCoreMLModel, completionHandler: completionHandler)
    }
}

extension LiveImageViewController {
    func handleObjectDetection(request: VNRequest, error: Error?) {
        guard let results = request.results else { return }
        DispatchQueue.main.async {
            self.drawVisionRequestResults(results)
        }
    }
}

extension LiveImageViewController {
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil    // remove all the old recognized objects
        
        for observation in results {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                    continue
            }
            
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(videoBufferSize.width), Int(videoBufferSize.height))
            
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            let text = String(format: "\(topLabelObservation.identifier)\nconfidence: %.2f", topLabelObservation.confidence)
            
            let textLayer = self.createTextSubLayerInBounds(objectBounds, text: text)
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
        }
        updateLayerGeometry()
        
        CATransaction.commit()
    }
}

extension LiveImageViewController {
    func createTextSubLayerInBounds(_ bounds: CGRect, text: String) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.foregroundColor = UIColor.blue.cgColor
        
        // Rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }
    
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
}

extension LiveImageViewController {
    func updateLayerGeometry() {
        let rootLayer = detectionOverlay.superlayer!
        let bounds = rootLayer.bounds
        
        let xScale: CGFloat = bounds.size.width / videoBufferSize.height
        let yScale: CGFloat = bounds.size.height / videoBufferSize.width
        
        var scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        // Rotate the layer into screen orientation and scale and mirror
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
