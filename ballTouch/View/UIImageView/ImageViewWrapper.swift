//
//  ImageViewWrapper.swift
//  running
//
//  Created by najak on 9/28/25.
//

import SwiftUI
import UIKit

struct ImageViewWrapper: UIViewRepresentable {
    let uiImage: UIImage
    
    func makeUIView(context: Context) -> UIImageView {
        return UIImageView()
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = uiImage
    }
}
