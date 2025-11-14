//
//  ParametricEQView.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

struct ParametricEQView: View {
    @EnvironmentObject var eqViewModel: EQViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Parametric EQ")
                    .font(.headline)
                
                Spacer()
                
                Button("Add Band") {
                    // Add new parametric band
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            
            // Parametric bands list
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(eqViewModel.parametricBands.indices, id: \.self) { index in
                        ParametricBandRow(
                            band: eqViewModel.parametricBands[index],
                            index: index,
                            onUpdate: { frequency, gain, q, filterType, isEnabled in
                                eqViewModel.updateParametricBand(
                                    at: index,
                                    frequency: frequency,
                                    gain: gain,
                                    q: q,
                                    filterType: filterType,
                                    isEnabled: isEnabled
                                )
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            
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
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

struct ParametricBandRow: View {
    let band: ParametricBand
    let index: Int
    let onUpdate: (Double?, Double?, Double?, ParametricBand.FilterType?, Bool?) -> Void
    
    @State private var frequency: Double
    @State private var gain: Double
    @State private var q: Double
    @State private var filterType: ParametricBand.FilterType
    @State private var isEnabled: Bool
    
    init(band: ParametricBand, index: Int, onUpdate: @escaping (Double?, Double?, Double?, ParametricBand.FilterType?, Bool?) -> Void) {
        self.band = band
        self.index = index
        self.onUpdate = onUpdate
        
        self._frequency = State(initialValue: band.frequency)
        self._gain = State(initialValue: band.gain)
        self._q = State(initialValue: band.q)
        self._filterType = State(initialValue: band.filterType)
        self._isEnabled = State(initialValue: band.isEnabled)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Enable toggle
                Toggle("", isOn: $isEnabled)
                    .toggleStyle(.switch)
                    .onChange(of: isEnabled) { newValue in
                        onUpdate(nil, nil, nil, nil, newValue)
                    }
                
                // Band number
                Text("Band \(index + 1)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                // Filter type picker
                Picker("Filter", selection: $filterType) {
                    ForEach(ParametricBand.FilterType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100)
                .onChange(of: filterType) { newValue in
                    onUpdate(nil, nil, nil, newValue, nil)
                }
            }
            
            HStack(spacing: 16) {
                // Frequency control
                VStack(alignment: .leading) {
                    Text("Frequency")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Slider(
                            value: Binding(
                                get: { frequency },
                                set: { newValue in
                                    frequency = newValue
                                    onUpdate(newValue, nil, nil, nil, nil)
                                }
                            ),
                            in: 20...20000,
                            step: 1
                        )
                        
                        Text(formatFrequency(frequency))
                            .font(.caption)
                            .frame(width: 50)
                    }
                }
                
                // Gain control
                VStack(alignment: .leading) {
                    Text("Gain")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Slider(
                            value: Binding(
                                get: { gain },
                                set: { newValue in
                                    gain = newValue
                                    onUpdate(nil, newValue, nil, nil, nil)
                                }
                            ),
                            in: -20...20,
                            step: 0.1
                        )
                        
                        Text(String(format: "%.1f", gain))
                            .font(.caption)
                            .frame(width: 40)
                    }
                }
                
                // Q control
                VStack(alignment: .leading) {
                    Text("Q Factor")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Slider(
                            value: Binding(
                                get: { q },
                                set: { newValue in
                                    q = newValue
                                    onUpdate(nil, nil, newValue, nil, nil)
                                }
                            ),
                            in: 0.1...10,
                            step: 0.1
                        )
                        
                        Text(String(format: "%.1f", q))
                            .font(.caption)
                            .frame(width: 40)
                    }
                }
            }
        }
        .padding()
        .background(isEnabled ? Color(NSColor.textBackgroundColor) : Color.gray.opacity(0.1))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isEnabled ? Color.primary : Color.gray, lineWidth: 1)
        )
    }
    
    private func formatFrequency(_ frequency: Double) -> String {
        if frequency >= 1000 {
            return String(format: "%.1fk", frequency / 1000.0)
        } else {
            return String(format: "%.0f", frequency)
        }
    }
}

struct ParametricEQView_Previews: PreviewProvider {
    static var previews: some View {
        ParametricEQView()
            .environmentObject(EQViewModel())
            .frame(width: 600, height: 400)
    }
}