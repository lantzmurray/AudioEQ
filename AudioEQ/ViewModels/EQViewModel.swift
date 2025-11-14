//
//  EQViewModel.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation
import Combine

class EQViewModel: ObservableObject {
    @Published var currentEQSettings: EQSettings = .flat
    @Published var mode: EQMode = .graphic
    @Published var isEnabled: Bool = true
    @Published var graphicBands: [GraphicBand] = []
    @Published var parametricBands: [ParametricBand] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let presetManager = PresetManager()
    
    init() {
        // Initialize with default EQ settings
        updateBandsFromSettings()
        
        // Update bands when settings change
        $currentEQSettings
            .sink { [weak self] settings in
                self?.updateBandsFromSettings()
            }
            .store(in: &cancellables)
    }
    
    private func updateBandsFromSettings() {
        graphicBands = currentEQSettings.graphicBands
        parametricBands = currentEQSettings.parametricBands
    }
    
    func updateGraphicBand(at index: Int, gain: Double) {
        guard index < graphicBands.count else { return }
        
        graphicBands[index].gain = gain
        updateEQSettingsFromBands()
    }
    
    func updateParametricBand(at index: Int, frequency: Double? = nil, gain: Double? = nil, q: Double? = nil, filterType: ParametricBand.FilterType? = nil, isEnabled: Bool? = nil) {
        guard index < parametricBands.count else { return }
        
        var band = parametricBands[index]
        
        if let frequency = frequency {
            band.frequency = frequency
        }
        if let gain = gain {
            band.gain = gain
        }
        if let q = q {
            band.q = q
        }
        if let filterType = filterType {
            band.filterType = filterType
        }
        if let isEnabled = isEnabled {
            band.isEnabled = isEnabled
        }
        
        parametricBands[index] = band
        updateEQSettingsFromBands()
    }
    
    private func updateEQSettingsFromBands() {
        let updatedSettings = EQSettings(
            name: currentEQSettings.name,
            mode: mode
        )
        
        // Create new settings with updated bands
        // Note: This is a simplified approach - in a real implementation,
        // we'd want to preserve the original EQSettings object and update it
        currentEQSettings = EQSettings(
            name: currentEQSettings.name,
            mode: mode
        )
        
        // Update the bands (this would need proper implementation in EQSettings)
        // For now, we'll trigger a notification that settings have changed
        objectWillChange.send()
    }
    
    func resetToFlat() {
        currentEQSettings = .flat
        updateBandsFromSettings()
    }
    
    func savePreset(name: String) {
        let newSettings = EQSettings(name: name, mode: mode)
        presetManager.savePreset(newSettings)
    }
    
    func loadPreset(_ preset: EQSettings) {
        currentEQSettings = preset
        mode = preset.mode
        updateBandsFromSettings()
    }
    
    func deletePreset(_ preset: EQSettings) {
        presetManager.deletePreset(preset)
    }
    
    func getAllPresets() -> [EQSettings] {
        return presetManager.getAllPresets()
    }
}