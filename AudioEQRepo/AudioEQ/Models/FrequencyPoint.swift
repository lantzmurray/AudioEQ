//
//  FrequencyPoint.swift
//  AudioEQ
//
//  Created by Lantz on 11/15/25.
//



import Foundation

struct FrequencyPoint: Identifiable, Codable {
    let id: UUID
    var frequency: Double
    var amplitude: Double   // in dB

    init(frequency: Double, amplitude: Double) {
        self.id = UUID()
        self.frequency = frequency
        self.amplitude = amplitude
    }
}
