//
//  ObjectiveInputView.swift
//  ballTouch
//
//  Created by najak on 10/9/25.
//

import SwiftUI

struct ObjectiveInputView: View {
    @Binding var selectedGameObjective: GameObjective
    @State private var objectiveTarget: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color("1F2020"))
                    })
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 0)
                
                TextField("Objective", text: $objectiveTarget)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Spacer()
            }
        }
    }
}
