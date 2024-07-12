////
////  ExpressionManager.swift
////  VisionPlus
////
////  Created by mac.bernanda on 12/07/24.
////
//import Vision
//import UIKit
//
//class ImagePredictor {
//    static func createImageClassifier() -> VNCoreMLModel {
//        let defaultConfig = MLModelConfiguration()
//        
//        
//        let imageClassifierWrapper = try? ObjectPredictor(configuration: defaultConfig)
//        
//        guard let imageClassifier = imageClassifierWrapper else {
//            fatalError("App failed to create an image classifier model instance.")
//        }
//        
//        let imageClassifierModel = imageClassifier.model
//        
//        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
//            fatalError("App failed to create a `VNCoreMLModel` instance.")
//        }
//        
//        return imageClassifierVisionModel
//    }
//    
//    private static let imageClassifier = createImageClassifier()
//    
//    struct Prediction {
//        /// The name of the object or scene the image classifier recognizes in an image.
//        let classification: String
//        let confidencePercentage: Float
//    }
//    
//    typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void
//    
//    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
//    
//    private func createImageClassificationRequest() -> VNImageBasedRequest {
//        let imageClassificationRequest = VNCoreMLRequest(model: ImagePredictor.imageClassifier,
//                                                         completionHandler: visionRequestHandler)
//        
//        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
//        return imageClassificationRequest
//    }
//    
//    
//    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws {
//        let orientation = CGImagePropertyOrientation(photo.imageOrientation)
//        
//        guard let photoImage = photo.cgImage else {
//            fatalError("Photo doesn't have underlying CGImage.")
//        }
//        
//        let imageClassificationRequest = createImageClassificationRequest()
//        predictionHandlers[imageClassificationRequest] = completionHandler
//        
//        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
//        let requests: [VNRequest] = [imageClassificationRequest]
//        
//        // Start the image classification request.
//        try handler.perform(requests)
//    }
//    
//    
//    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
//        // Remove the caller's handler from the dictionary and keep a reference to it.
//        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
//            fatalError("Every request must have a prediction handler.")
//        }
//        
//        // Start with a `nil` value in case there's a problem.
//        var predictions: [Prediction]? = nil
//        
//        // Call the client's completion handler after the method returns.
//        defer {
//            // Send the predictions back to the client.
//            predictionHandler(predictions)
//        }
//        
//        // Check for an error first.
//        if let error = error {
//            print("Vision image classification error...\n\n\(error.localizedDescription)")
//            return
//        }
//        
//        // Check that the results aren't `nil`.
//        if request.results == nil {
//            print("Vision request had no results.")
//            return
//        }
//        
//        guard let observations = request.results as? [VNClassificationObservation] else {
//        
//            print("VNRequest produced the wrong result type: \(type(of: request.results)).")
//            return
//        }
//        
//        // Create a prediction array from the observations.
//        predictions = observations.map { observation in
//            Prediction(classification: observation.identifier,
//                       confidencePercentage: observation.confidence)
//        }
//    }
//}
//
//extension CGImagePropertyOrientation {
//    init(_ orientation: UIImage.Orientation) {
//        switch orientation {
//        case .up: self = .up
//        case .down: self = .down
//        case .left: self = .left
//        case .right: self = .right
//        case .upMirrored: self = .upMirrored
//        case .downMirrored: self = .downMirrored
//        case .leftMirrored: self = .leftMirrored
//        case .rightMirrored: self = .rightMirrored
//        @unknown default: self = .up
//        }
//    }
//}
