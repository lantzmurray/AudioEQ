//
//  PresetManager.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation

class PresetManager {
    private let userDefaults = UserDefaults.standard
    private let presetsKey = "EQPresets"
    
    func savePreset(_ preset: EQSettings) {
        var presets = getAllPresets()
        presets.append(preset)
        savePresets(presets)
    }
    
    func getAllPresets() -> [EQSettings] {
        guard let data = userDefaults.data(forKey: presetsKey),
              let presets = try? JSONDecoder().decode([EQSettings].self, from: data) else {
            return getDefaultPresets()
        }
        return presets
    }
    
    func deletePreset(_ preset: EQSettings) {
        var presets = getAllPresets()
        presets.removeAll { $0.id == preset.id }
        savePresets(presets)
    }
    
    func updatePreset(_ preset: EQSettings) {
        var presets = getAllPresets()
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            presets[index] = preset
            savePresets(presets)
        }
    }
    
    private func savePresets(_ presets: [EQSettings]) {
        guard let data = try? JSONEncoder().encode(presets) else { return }
        userDefaults.set(data, forKey: presetsKey)
    }
    
    private func getDefaultPresets() -> [EQSettings] {
        return [
            EQSettings.flat,
            EQSettings(name: "Vocal Boost", mode: .graphic),
            EQSettings(name: "Bass Boost", mode: .graphic),
            EQSettings(name: "Treble Boost", mode: .graphic),
            EQSettings(name: "Rock", mode: .graphic),
            EQSettings(name: "Jazz", mode: .graphic),
            EQSettings(name: "Classical", mode: .graphic),
            EQSettings(name: "Electronic", mode: .graphic)
        ]
    }
    
    func createPresetFromGraphicBands(_ bands: [GraphicBand], name: String) -> EQSettings {
        var preset = EQSettings(name: name, mode: .graphic)
        preset.graphicBands = bands
        return preset
    }
    
    func createPresetFromParametricBands(_ bands: [ParametricBand], name: String) -> EQSettings {
        var preset = EQSettings(name: name, mode: .parametric)
        preset.parametricBands = bands
        return preset
    }
    
    func exportPresets() -> URL? {
        let presets = getAllPresets()
        guard let data = try? JSONEncoder().encode(presets) else { return nil }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("AudioEQ_Presets.json")
        
        try? data.write(to: fileURL)
        return fileURL
    }
    
    func importPresets(from url: URL) -> [EQSettings]? {
        guard let data = try? Data(contentsOf: url),
              let presets = try? JSONDecoder().decode([EQSettings].self, from: data) else {
            return nil
        }
        
        var existingPresets = getAllPresets()
        existingPresets.append(contentsOf: presets)
        savePresets(existingPresets)
        
        return presets
    }
}

// Extension to make EQSettings codable work properly
extension EQSettings {
    enum CodingKeys: String, CodingKey {
        case id, name, mode, graphicBands, parametricBands, isEnabled
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(mode, forKey: .mode)
        try container.encode(graphicBands, forKey: .graphicBands)
        try container.encode(parametricBands, forKey: .parametricBands)
        try container.encode(isEnabled, forKey: .isEnabled)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        mode = try container.decode(EQMode.self, forKey: .mode)
        graphicBands = try container.decode([GraphicBand].self, forKey: .graphicBands)
        parametricBands = try container.decode([ParametricBand].self, forKey: .parametricBands)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
    }
}