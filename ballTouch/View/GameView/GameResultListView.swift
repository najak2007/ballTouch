//
//  GameResultListView.swift
//  ballTouch
//
//  Created by najak on 10/22/25.
//

import SwiftUI
import Foundation

struct GameResultListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedGameObjective: GameObjective
    @Binding var score: Int
    @Binding var savedScoreIndex: Int
    @Binding var savedTimeIndex: Int
    
    @State private var pickerLastIndex: Int = 7
    
    @State private var pointTableIndex: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
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
                
                Form {
                    Section {
                        if self.selectedGameObjective == .합산_점수 {
                            Picker("", selection: $pointTableIndex) {
                                if self.selectedGameObjective == .합산_점수 {
                                    ForEach(1..<7) { tableValue in
                                        Text("\(tableValue) 초")
                                    }
                                }
                            }
                            .pickerStyle(.segmented)
                        } else {
                            Picker("", selection: $pointTableIndex) {
                                ForEach(1..<11) { tableValue in
                                    Text("\(tableValue) 초")
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(Color("1F2020"))
                        }
                    }
                }
                    
                Spacer()
            }
            .navigationTitle("점수")
        }
        .onAppear {
            self.pickerLastIndex = self.selectedGameObjective == .합산_점수 ? 7 : 11
        }
    }
}
