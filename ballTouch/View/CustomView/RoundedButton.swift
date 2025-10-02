//
//  RoundedButton.swift
//  running
//
//  Created by najak on 9/4/25.
//

import SwiftUI

struct RoundedButton: View {
    var leadingImage: Image? = nil
    var title: String
    var trailingImage: Image? = nil
    var fontSize: CGFloat = 18
    var fontName: String = "GmarketSansTTFMedium"
    var backgroundColor: Color = Color(hex: "#EAFFFF")
    var foregroundColor: Color = Color(hex: "#222222")
    var height: CGFloat = 40
    var action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                if leadingImage != nil || trailingImage != nil {
                    HStack(spacing: 4) {
                        if leadingImage != nil {
                            leadingImage!
                            
                            Text(title)
                            
                        }
                        
                        if trailingImage != nil {
                            trailingImage
                        }
                    }
                } else {
                    Text(title)
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: 100, maxHeight: height)
            .padding(.horizontal, 8)
            .font(.custom(fontName, size: fontSize))
            .background(backgroundColor)                    // 배경색 설정
            .foregroundStyle(foregroundColor)               // 글자 색상 설정
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
