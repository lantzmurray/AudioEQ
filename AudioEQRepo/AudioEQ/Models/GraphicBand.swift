//
//  GraphicBand.swift
//  AudioEQ
//
//  Created by Lantz on 11/15/25.
//

import Foundation


struct GraphicBand: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var frequency: Double
    var gain: Double

    init(
        id: UUID = UUID(),
        frequency: Double,
        gain: Double
    ) {
        self.id = id
        self.frequency = frequency
        self.gain = gain
    }
}
