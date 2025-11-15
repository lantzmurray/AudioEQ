//
//  PresetManager.swift
//  AudioEQ
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
            .flat,
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
        var preset = EQSettings(name: name, mode: .graphic, graphicBands: [], parametricBands: [])
        preset.graphicBands = bands   // works now because property is var
        return preset
    }
    
    func createPresetFromParametricBands(_ bands: [ParametricBand], name: String) -> EQSettings {
        var preset = EQSettings(name: name, mode: .parametric, graphicBands: [], parametricBands: [])
        preset.parametricBands = bands   // works now because property is var
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
