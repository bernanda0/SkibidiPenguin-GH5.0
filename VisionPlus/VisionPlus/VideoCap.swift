//
//  VideoCap.swift
//  VisionPlus
//
//  Created by Althaf Nafi Anwar on 12/07/24.
//

import Foundation
import AVFoundation
import Vision

class VideoCap: NSObject {
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    
    let predictor = Predictor()
    let expressionDetector = ExpressionDetector()
    
    override init() {
        super.init()
        
        guard let captureDevice =  AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }
        
        captureSession.sessionPreset =  AVCaptureSession.Preset.high
        captureSession.addInput(input)
        
        captureSession.addOutput(videoOutput)
        videoOutput.alwaysDiscardsLateVideoFrames = true
    }
    
    func startCapturingSession() {
        captureSession.startRunning()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQueue"))
    }
}

extension VideoCap: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // Predict action
        predictor.estimation(sampleBuffer: sampleBuffer)
        
        // Expression
        expressionDetector.classify(sampleBuffer: sampleBuffer)
        
    }
    
}
