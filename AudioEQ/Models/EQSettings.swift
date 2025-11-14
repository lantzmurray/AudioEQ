//
//  EQSettings.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation

enum EQMode: String, CaseIterable {
    case graphic = "Graphic"
    case parametric = "Parametric"
}

struct EQSettings: Identifiable, Codable {
    let id: UUID
    let name: String
    let mode: EQMode
    let graphicBands: [GraphicBand]
    let parametricBands: [ParametricBand]
    let isEnabled: Bool
    
    init(name: String, mode: EQMode = .graphic) {
        self.id = UUID()
        self.name = name
        self.mode = mode
        self.graphicBands = Self.defaultGraphicBands()
        self.parametricBands = Self.defaultParametricBands()
        self.isEnabled = true
    }
    
    private static func defaultGraphicBands() -> [GraphicBand] {
        let frequencies = [31, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
        return frequencies.map { GraphicBand(frequency: $0, gain: 0.0) }
    }
    
    private static func defaultParametricBands() -> [ParametricBand] {
        return [
            ParametricBand(frequency: 60, gain: 0.0, q: 1.0, filterType: .bell, isEnabled: true),
            ParametricBand(frequency: 250, gain: 0.0, q: 1.0, filterType: .bell, isEnabled: true),
            ParametricBand(frequency: 1000, gain: 0.0, q: 1.0, filterType: .bell, isEnabled: true),
            ParametricBand(frequency: 4000, gain: 0.0, q: 1.0, filterType: .bell, isEnabled: true),
            ParametricBand(frequency: 10000, gain: 0.0, q: 1.0, filterType: .bell, isEnabled: true)
        ]
    }
}

struct GraphicBand: Identifiable, Codable {
    let id = UUID()
    let frequency: Int
    var gain: Double // -20.0 to +20.0 dB
    
    init(frequency: Int, gain: Double = 0.0) {
        self.frequency = frequency
        self.gain = max(-20.0, min(20.0, gain))
    }
}

struct ParametricBand: Identifiable, Codable {
    let id = UUID()
    var frequency: Double // 20Hz to 20kHz
    var gain: Double // -20.0 to +20.0 dB
    var q: Double // 0.1 to 10.0
    var filterType: FilterType
    var isEnabled: Bool
    
    enum FilterType: String, CaseIterable, Codable {
        case bell = "Bell"
        case lowShelf = "Low Shelf"
        case highShelf = "High Shelf"
        case lowPass = "Low Pass"
        case highPass = "High Pass"
    }
    
    init(frequency: Double, gain: Double = 0.0, q: Double = 1.0, filterType: FilterType = .bell, isEnabled: Bool = true) {
        self.frequency = max(20.0, min(20000.0, frequency))
        self.gain = max(-20.0, min(20.0, gain))
        self.q = max(0.1, min(10.0, q))
        self.filterType = filterType
        self.isEnabled = isEnabled
    }
}

extension EQSettings {
    static let flat = EQSettings(name: "Flat")
    static let vocalBoost = EQSettings(name: "Vocal Boost")
    static let bassBoost = EQSettings(name: "Bass Boost")
}