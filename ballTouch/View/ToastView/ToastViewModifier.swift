//
//  ToastViewModifier.swift
//  TodayToDoList
//
//  Created by najak on 7/16/25.
//

import SwiftUI

struct ToastViewModifier: ViewModifier {
    @Binding var toast: Toast?
    var dismissToastHandler: (() -> Void)?
    
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                if toast.position == .Bottom {
                    Spacer()
                    
                    ToastView(
                        type: toast.type,
                        title: toast.title,
                        message: toast.message) {
                            dismissToast()
                        }
                } else if toast.position == .Top {
                    ToastView(
                        type: toast.type,
                        title: toast.title,
                        message: toast.message) {
                            dismissToast()
                        }
                    
                    Spacer()
                } else if toast.position == .Center {
                    Spacer()
                    
                    ToastView(
                        type: toast.type,
                        title: toast.title,
                        message: toast.message) {
                            dismissToast()
                        }
                    
                    Spacer()
                }
            }
            .transition(.move(edge: toast.position == .Top ? .top : .bottom))
        }
    }
    
    private func showToast() {
        guard let toast = toast else {
            return
        }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()

            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
        dismissToastHandler?()
    }
}

extension View {
    func toastView(toast: Binding<Toast?>, dismissToastHandler: (() -> Void)? = nil) -> some View {
        self.modifier(ToastViewModifier(toast: toast, dismissToastHandler: dismissToastHandler))
    }
}
