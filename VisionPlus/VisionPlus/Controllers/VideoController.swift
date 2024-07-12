//
//  VideoController.swift
//  VisionPlus
//
//  Created by mac.bernanda on 12/07/24.
//

import UIKit
import SwiftUI
import AVFoundation
import Vision


class VideoDetectorController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var permissionGranted = false // Flag for permission
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect = UIScreen.main.bounds
    
    // Speech Synthesizer
    let speechSynthesizer = AVSpeechSynthesizer()
    
    // Detector
    private var videoOutput = AVCaptureVideoDataOutput()
    var requests = [VNRequest]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        
        sessionQueue.async { [weak self] in
            guard let self = self, self.permissionGranted else { return }
            self.setupCaptureSession()
            self.setupClassifier()
            self.captureSession.startRunning()
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCaptureSession()
    }
    
    func stopCaptureSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        
        switch UIDevice.current.orientation {
        case .portraitUpsideDown:
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
        case .portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
        default:
            break
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            self?.permissionGranted = granted
            self?.sessionQueue.resume()
        }
    }
    
    func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput) else { return }
        
        captureSession.addInput(videoDeviceInput)
        
        // Preview layer
        screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .landscapeRight
        
        // Detector
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .landscapeRight
        
        // Updates to UI must be on main queue
        DispatchQueue.main.async { [weak self] in
            if let previewLayer = self?.previewLayer {
                self?.view.layer.addSublayer(previewLayer)
            }
        }
    }
}
