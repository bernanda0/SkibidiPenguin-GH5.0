//
//  CameraView.swift
//  VisionPlus
//
//  Created by mac.bernanda on 12/07/24.
//

//
//  ObjectScanView.swift
//  SleuthVision
//
//  Created by mac.bernanda on 29/04/24.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VideoDetectorView().ignoresSafeArea()
            }
        }
        
    }
}

struct VideoDetectorView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = VideoDetectorController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}


