//
//  GraphicEQView.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

struct GraphicEQView: View {
    @EnvironmentObject var eqViewModel: EQViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Frequency labels
            HStack {
                ForEach(eqViewModel.graphicBands.indices, id: \.self) { index in
                    VStack {
                        Spacer()
                        
                        Text(formatFrequency(eqViewModel.graphicBands[index].frequency))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 20)
            
            // EQ sliders
            HStack(spacing: 12) {
                ForEach(eqViewModel.graphicBands.indices, id: \.self) { index in
                    VStack(spacing: 8) {
                        // Gain value display
                        Text(String(format: "%.1f", eqViewModel.graphicBands[index].gain))
                            .font(.caption)
                            .foregroundColor(eqViewModel.graphicBands[index].gain == 0 ? .primary : .blue)
                        
                        // Slider
                        Slider(
                            value: Binding(
                                get: { eqViewModel.graphicBands[index].gain },
                                set: { newValue in
                                    eqViewModel.updateGraphicBand(at: index, gain: newValue)
                                }
                            ),
                            in: -20...20,
                            step: 0.1
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 100, height: 20)
                        .accentColor(eqViewModel.graphicBands[index].gain == 0 ? .gray : .blue)
                        
                        Spacer()
                    }
                }
            }
            .frame(height: 150)
            
            // Zero line indicator
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .padding(.horizontal, 20)
            
            // Control buttons
            HStack {
                Button("Reset") {
                    eqViewModel.resetToFlat()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Toggle("Enable EQ", isOn: $eqViewModel.isEnabled)
                    .toggleStyle(.switch)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
    
    private func formatFrequency(_ frequency: Int) -> String {
        if frequency >= 1000 {
            return String(format: "%.1fk", Double(frequency) / 1000.0)
        } else {
            return "\(frequency)"
        }
    }
}

struct GraphicEQView_Previews: PreviewProvider {
    static var previews: some View {
        GraphicEQView()
            .environmentObject(EQViewModel())
            .frame(width: 600, height: 300)
    }
}