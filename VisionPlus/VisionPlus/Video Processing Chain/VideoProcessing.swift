//
//  VideoProcessing.swift
//  VisionPlus
//
//  Created by Althaf Nafi Anwar on 12/07/24.
//

import Foundation
import Vision

class VideoProcessing: VideoProcessingChainDelegate, VideoCaptureDelegate {

    var videoProcessingChain: VideoProcessingChain = VideoProcessingChain()
    var videoCapture: VideoCapture = VideoCapture()
    
    init() {
        self.videoProcessingChain.delegate = self
        self.videoCapture.delegate = self
    }
    
    func videoCapture(_ videoCapture: VideoCapture,
                      didCreate framePublisher: FramePublisher) {
        debugPrint("video capturing")
        // Build a new video-processing chain by assigning the new frame publisher.
        videoProcessingChain.upstreamFramePublisher = framePublisher
    }
    
    func videoProcessingChain(_ chain: VideoProcessingChain,
                              didPredict actionPrediction: ActionPrediction,
                              for frameCount: Int) {

        if actionPrediction.isModelLabel {
            // Update the total number of frames for this action.
            debugPrint("YES")
        }

        debugPrint(actionPrediction)
//        // Present the prediction in the UI.
//        updateUILabelsWithPrediction(actionPrediction)
    }

    /// Receives a frame and any poses in that frame.
    /// - Parameters:
    ///   - chain: A video-processing chain.
    ///   - poses: A `Pose` array.
    ///   - frame: A video frame as a `CGImage`.
    func videoProcessingChain(_ chain: VideoProcessingChain,
                              didDetect poses: [Pose]?,
                              in frame: CGImage) {
        // Render the poses on a different queue than pose publisher.
        DispatchQueue.global(qos: .userInteractive).async {
            // Draw the poses onto the frame.
//            debugPrint("")
//            self.drawPoses(poses, onto: frame)
        }
    }
    
    
}
