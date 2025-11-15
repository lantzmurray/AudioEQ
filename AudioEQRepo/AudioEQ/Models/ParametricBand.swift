//
//  ParametricBand.swift
//  AudioEQ
//

import Foundation

struct ParametricBand: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var frequency: Double
    var gain: Double
    var q: Double
    var filterType: FilterType
    var isEnabled: Bool

    // THE ONLY FILTERTYPE IN THE PROJECT
    enum FilterType: String, Codable, CaseIterable {
        case bell
        case lowShelf
        case highShelf
        case lowPass
        case highPass
    }

    init(
        id: UUID = UUID(),
        frequency: Double,
        gain: Double,
        q: Double,
        filterType: FilterType = .bell,
        isEnabled: Bool = true
    ) {
        self.id = id
        self.frequency = frequency
        self.gain = gain
        self.q = q
        self.filterType = filterType
        self.isEnabled = isEnabled
    }
}
