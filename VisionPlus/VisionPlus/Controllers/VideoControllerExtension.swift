//
//  VideoControllerExtension.swift
//  VisionPlus
//
//  Created by mac.bernanda on 12/07/24.
//

import Vision
import AVFoundation
import UIKit

extension VideoDetectorController {
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
        DispatchQueue.main.async {
            if let results = request.results as? [VNClassificationObservation] {
                self.handleClassifications(classifications: results)
            }
        }
    }
    
    func handleClassifications(classifications: [VNClassificationObservation]) {
        for classification in classifications {
            if (classification.confidence > 0.9) {
                print("Classification: \(classification.identifier) - Confidence: \(classification.confidence)")
                speakText("\(classification.identifier) boy detected")

            }
            
        }
    }
    
    func speakText(_ text: String) {
           let utterance = AVSpeechUtterance(string: text)
           utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
           speechSynthesizer.speak(utterance)
       }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print("Error performing classification: \(error)")
        }
    }
}
