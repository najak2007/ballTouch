//
//  MenuWrapperView.swift
//  ballTouch
//
//  Created by najak on 10/15/25.
//
import SwiftUI
import UIKit

struct Menu: UIViewRepresentable {
    
    @Binding var selectionIndex: Int
    var actionHandler: ((Int) -> Void)? = nil
    
    func makeUIView(context: Context) -> MenuButton {
        let menuButton = MenuButton(frame: .zero, selectionIndex: selectionIndex)
        menuButton.actionHandler = actionHandler
        return menuButton
    }
    
    func updateUIView(_ uiView: MenuButton, context: Context) {
        uiView.setTitle("\((selectionIndex + 1) * 10)초", for: .normal)
    }
}
