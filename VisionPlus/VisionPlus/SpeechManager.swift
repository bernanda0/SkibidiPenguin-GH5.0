//
//  SpeechManager.swift
//  VisionPlus
//
//  Created by Althaf Nafi Anwar on 12/07/24.
//

import Foundation
import AVFAudio


class SpeechManager {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    static let shared = SpeechManager()
    
    func speakText(_ text: String) {
       let utterance = AVSpeechUtterance(string: text)
       utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
       speechSynthesizer.speak(utterance)
   }
}
