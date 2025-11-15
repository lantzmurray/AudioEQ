import Foundation
import Combine

class EQViewModel: ObservableObject {
    @Published var currentEQSettings: EQSettings = .flat
    @Published var mode: EQMode = .graphic
    @Published var isEnabled: Bool = true
    @Published var graphicBands: [GraphicBand] = []
    @Published var parametricBands: [ParametricBand] = []
    
    private let presetManager = PresetManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        updateBandsFromSettings()
        
        // When settings change, sync bands
        $currentEQSettings
            .sink { [weak self] _ in
                self?.updateBandsFromSettings()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Internal Sync
    
    private func updateBandsFromSettings() {
        graphicBands = currentEQSettings.graphicBands
        parametricBands = currentEQSettings.parametricBands
    }
    
    private func pushBandsToSettings() {
        currentEQSettings = EQSettings(
            name: currentEQSettings.name,
            mode: mode,
            graphicBands: graphicBands,
            parametricBands: parametricBands
        )
    }
    
    // MARK: - Band Editing
    
    func updateGraphicBand(at index: Int, gain: Double) {
        guard index < graphicBands.count else { return }
        graphicBands[index].gain = gain
        pushBandsToSettings()
    }
    
    func updateParametricBand(
        at index: Int,
        frequency: Double? = nil,
        gain: Double? = nil,
        q: Double? = nil,
        filterType: ParametricBand.FilterType? = nil,
        isEnabled: Bool? = nil
    ) {
        guard index < parametricBands.count else { return }
        
        var band = parametricBands[index]
        if let f = frequency { band.frequency = f }
        if let g = gain { band.gain = g }
        if let qVal = q { band.q = qVal }
        if let ft = filterType { band.filterType = ft }
        if let enabled = isEnabled { band.isEnabled = enabled }
        
        parametricBands[index] = band
        pushBandsToSettings()
    }
    
    // MARK: - Presets / Reset
    
    func resetToFlat() {
        currentEQSettings = .flat
        updateBandsFromSettings()
    }
    
    func savePreset(name: String) {
        let preset = EQSettings(
            name: name,
            mode: mode,
            graphicBands: graphicBands,
            parametricBands: parametricBands
        )
        presetManager.savePreset(preset)
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
        presetManager.getAllPresets()
    }
}

