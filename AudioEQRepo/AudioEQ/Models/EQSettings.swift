//
//  EQSettings.swift
//  AudioEQ
//

import Foundation

struct EQSettings: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var mode: EQMode
    var graphicBands: [GraphicBand]
    var parametricBands: [ParametricBand]
    var isEnabled: Bool

    // ✅ This initializer makes all the old calls like
    // EQSettings(name: "Bass Boost", mode: .graphic)
    // compile again (DeviceProfile, EQViewModel, PresetManager).
    init(id: UUID = UUID(),
         name: String,
         mode: EQMode,
         graphicBands: [GraphicBand] = [],
         parametricBands: [ParametricBand] = [],
         isEnabled: Bool = true) {
        self.id = id
        self.name = name
        self.mode = mode
        self.graphicBands = graphicBands
        self.parametricBands = parametricBands
        self.isEnabled = isEnabled
    }
}

enum EQMode: String, Codable, CaseIterable {
    case graphic
    case parametric
}


// ✅ Restores EQSettings.flat so all "flat" references compile.
extension EQSettings {
    static let flat = EQSettings(name: "Flat", mode: .graphic)
}
