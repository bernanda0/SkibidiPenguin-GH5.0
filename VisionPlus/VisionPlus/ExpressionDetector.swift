//
//  Predictor+Expression.swift
//  VisionPlus
//
//  Created by Althaf Nafi Anwar on 12/07/24.
//

import Foundation
import CreateML
import Vision
import AVFoundation

class ExpressionDetector {
    private var permissionGranted = false // Flag for permission
    private var previewLayer = AVCaptureVideoPreviewLayer()
    let speechManager = SpeechManager.shared
    
    // Detector
    var requests = [VNRequest]()
    
    func setupClassifier() {
        do {
            let model = try VNCoreMLModel(for: ExpressionClassification().model)
            let classificationRequest = VNCoreMLRequest(model: model, completionHandler: classificationDidComplete)
            self.requests = [classificationRequest]
        } catch {
            print("Error setting up classifier: \(error)")
        }
    }
    
    func classificationDidComplete(request: VNRequest, error: Error?) {
        debugPrint("didComplete")
        DispatchQueue.main.async {
            if let results = request.results as? [VNClassificationObservation] {
                self.handleClassifications(classifications: results)
            }
        }
    }
    
    func handleClassifications(classifications: [VNClassificationObservation]) {
        debugPrint("handleClassifications")
        for classification in classifications {
            if (classification.confidence > 0.9) {
                print("Classification: \(classification.identifier) - Confidence: \(classification.confidence)")
                speechManager.speakText("\(classification.identifier) boy detected")
            }
        }
    }
    
    func classify(sampleBuffer: CMSampleBuffer) {
        debugPrint("classify")
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print("Error performing classification: \(error)")
        }
    }
}
