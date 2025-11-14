//
//  UserPreferencesManager.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation

class UserPreferencesManager: ObservableObject {
    static let shared = UserPreferencesManager()
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Keys
    private enum Keys {
        static let selectedDeviceID = "SelectedDeviceID"
        static let lastUsedPreset = "LastUsedPreset"
        static let autoStartProcessing = "AutoStartProcessing"
        static let showSpectrumAnalyzer = "ShowSpectrumAnalyzer"
        static let defaultEQMode = "DefaultEQMode"
        static let enableNotifications = "EnableNotifications"
        static let checkForUpdates = "CheckForUpdates"
        static let lastExternalDataUpdate = "LastExternalDataUpdate"
    }
    
    // MARK: - Properties
    @Published var selectedDeviceID: AudioDeviceID? {
        didSet {
            if let deviceID = selectedDeviceID {
                userDefaults.set(deviceID, forKey: Keys.selectedDeviceID)
            } else {
                userDefaults.removeObject(forKey: Keys.selectedDeviceID)
            }
        }
    }
    
    @Published var lastUsedPreset: UUID? {
        didSet {
            if let presetID = lastUsedPreset {
                userDefaults.set(presetID.uuidString, forKey: Keys.lastUsedPreset)
            } else {
                userDefaults.removeObject(forKey: Keys.lastUsedPreset)
            }
        }
    }
    
    @Published var autoStartProcessing: Bool {
        didSet {
            userDefaults.set(autoStartProcessing, forKey: Keys.autoStartProcessing)
        }
    }
    
    @Published var showSpectrumAnalyzer: Bool {
        didSet {
            userDefaults.set(showSpectrumAnalyzer, forKey: Keys.showSpectrumAnalyzer)
        }
    }
    
    @Published var defaultEQMode: EQMode {
        didSet {
            userDefaults.set(defaultEQMode.rawValue, forKey: Keys.defaultEQMode)
        }
    }
    
    @Published var enableNotifications: Bool {
        didSet {
            userDefaults.set(enableNotifications, forKey: Keys.enableNotifications)
        }
    }
    
    @Published var checkForUpdates: Bool {
        didSet {
            userDefaults.set(checkForUpdates, forKey: Keys.checkForUpdates)
        }
    }
    
    @Published var lastExternalDataUpdate: Date? {
        didSet {
            if let date = lastExternalDataUpdate {
                userDefaults.set(date, forKey: Keys.lastExternalDataUpdate)
            } else {
                userDefaults.removeObject(forKey: Keys.lastExternalDataUpdate)
            }
        }
    }
    
    // MARK: - Initialization
    private init() {
        loadPreferences()
    }
    
    // MARK: - Methods
    func loadPreferences() {
        selectedDeviceID = userDefaults.object(forKey: Keys.selectedDeviceID) as? AudioDeviceID
        lastUsedPreset = userDefaults.string(forKey: Keys.lastUsedPreset).flatMap { UUID(uuidString: $0) }
        autoStartProcessing = userDefaults.bool(forKey: Keys.autoStartProcessing)
        showSpectrumAnalyzer = userDefaults.bool(forKey: Keys.showSpectrumAnalyzer)
        defaultEQMode = EQMode(rawValue: userDefaults.string(forKey: Keys.defaultEQMode) ?? "Graphic") ?? .graphic
        enableNotifications = userDefaults.bool(forKey: Keys.enableNotifications)
        checkForUpdates = userDefaults.bool(forKey: Keys.checkForUpdates)
        lastExternalDataUpdate = userDefaults.object(forKey: Keys.lastExternalDataUpdate) as? Date
    }
    
    func resetToDefaults() {
        userDefaults.removeObject(forKey: Keys.selectedDeviceID)
        userDefaults.removeObject(forKey: Keys.lastUsedPreset)
        userDefaults.removeObject(forKey: Keys.autoStartProcessing)
        userDefaults.removeObject(forKey: Keys.showSpectrumAnalyzer)
        userDefaults.removeObject(forKey: Keys.defaultEQMode)
        userDefaults.removeObject(forKey: Keys.enableNotifications)
        userDefaults.removeObject(forKey: Keys.checkForUpdates)
        userDefaults.removeObject(forKey: Keys.lastExternalDataUpdate)
        
        loadPreferences()
    }
    
    func exportPreferences() -> URL? {
        let preferences: [String: Any] = [
            "selectedDeviceID": selectedDeviceID as Any,
            "lastUsedPreset": lastUsedPreset?.uuidString as Any,
            "autoStartProcessing": autoStartProcessing,
            "showSpectrumAnalyzer": showSpectrumAnalyzer,
            "defaultEQMode": defaultEQMode.rawValue,
            "enableNotifications": enableNotifications,
            "checkForUpdates": checkForUpdates,
            "lastExternalDataUpdate": lastExternalDataUpdate?.description as Any
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: preferences, options: .prettyPrinted) else {
            return nil
        }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("AudioEQ_Preferences.json")
        
        try? data.write(to: fileURL)
        return fileURL
    }
    
    func importPreferences(from url: URL) -> Bool {
        guard let data = try? Data(contentsOf: url),
              let preferences = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return false
        }
        
        // Import preferences
        if let deviceID = preferences["selectedDeviceID"] as? AudioDeviceID {
            selectedDeviceID = deviceID
        }
        
        if let presetString = preferences["lastUsedPreset"] as? String,
           let presetID = UUID(uuidString: presetString) {
            lastUsedPreset = presetID
        }
        
        if let autoStart = preferences["autoStartProcessing"] as? Bool {
            autoStartProcessing = autoStart
        }
        
        if let showSpectrum = preferences["showSpectrumAnalyzer"] as? Bool {
            showSpectrumAnalyzer = showSpectrum
        }
        
        if let modeString = preferences["defaultEQMode"] as? String,
           let mode = EQMode(rawValue: modeString) {
            defaultEQMode = mode
        }
        
        if let notifications = preferences["enableNotifications"] as? Bool {
            enableNotifications = notifications
        }
        
        if let updates = preferences["checkForUpdates"] as? Bool {
            checkForUpdates = updates
        }
        
        if let dateString = preferences["lastExternalDataUpdate"] as? String,
           let date = ISO8601DateFormatter().date(from: dateString) {
            lastExternalDataUpdate = date
        }
        
        return true
    }
    
    // MARK: - Convenience Methods
    func shouldUpdateExternalData() -> Bool {
        guard let lastUpdate = lastExternalDataUpdate else { return true }
        
        let daysSinceUpdate = Calendar.current.dateComponents([.day], from: lastUpdate, to: Date()).day ?? 0
        return daysSinceUpdate >= 7 // Update weekly
    }
    
    func markExternalDataUpdated() {
        lastExternalDataUpdate = Date()
    }
}

// MARK: - AudioDeviceID Extension
extension AudioDeviceID: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = try container.decode(Int.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self)
    }
}