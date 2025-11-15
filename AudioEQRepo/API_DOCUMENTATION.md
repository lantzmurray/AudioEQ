# AudioEQ API Documentation

This document provides detailed API documentation for the AudioEQ application, covering all public interfaces, data models, and service classes.

## Table of Contents

- [Core Models](#core-models)
- [Audio Engine](#audio-engine)
- [View Models](#view-models)
- [Services](#services)
- [Views](#views)
- [Core Audio Components](#core-audio-components)

## Core Models

### AudioDevice

Represents an audio output device in the system.

```swift
struct AudioDevice: Identifiable, Equatable, Codable, Hashable {
    typealias ID = UInt32
    
    let id: UInt32                    // Unique device identifier
    let name: String                  // Human-readable device name
    let manufacturer: String          // Device manufacturer
    let uid: String                   // Unique device UID
    let deviceType: DeviceType        // Type of connection
    let channels: Int                 // Number of audio channels
    let sampleRate: Double            // Supported sample rate
    
    enum DeviceType: String, CaseIterable, Codable {
        case builtIn = "Built-in"
        case usb = "USB"
        case bluetooth = "Bluetooth"
        case thunderbolt = "Thunderbolt"
        case hdmi = "HDMI"
        case other = "Other"
    }
}
```

#### Usage Example

```swift
let device = AudioDevice(
    id: 1,
    name: "Built-in Output",
    manufacturer: "Apple",
    uid: "AppleHDAEngineOutput:1B,0,1,0:1",
    deviceType: .builtIn,
    channels: 2,
    sampleRate: 44100.0
)
```

### DeviceProfile

Contains measurement data and recommended EQ settings for audio devices.

```swift
struct DeviceProfile: Identifiable, Codable {
    let id: UUID                      // Unique profile identifier
    let name: String                  // Profile name
    let manufacturer: String          // Device manufacturer
    let model: String                 // Device model
    let deviceType: DeviceType        // Type of audio device
    let frequencyResponse: [FrequencyPoint]  // Measurement data
    let recommendedEQ: EQSettings     // Recommended EQ settings
    let dataSource: DataSource        // Source of measurement data
    let dateAdded: Date               // When profile was added
    
    enum DeviceType: String, CaseIterable, Codable {
        case headphone = "Headphone"
        case inEar = "In-Ear Monitor"
        case studioMonitor = "Studio Monitor"
        case speaker = "Speaker"
        case earbud = "Earbud"
    }
    
    enum DataSource: String, CaseIterable, Codable {
        case local = "Local"
        case oratory1990 = "Oratory1990"
        case crinacle = "Crinacle"
        case custom = "Custom"
    }
}
```

#### Initialization

```swift
let profile = DeviceProfile(
    name: "HD 600",
    manufacturer: "Sennheiser",
    model: "HD 600",
    deviceType: .headphone,
    frequencyResponse: measurementData,
    recommendedEQ: targetEQ,
    dataSource: .oratory1990
)
```

### EQSettings

Represents EQ configuration settings for both graphic and parametric modes.

```swift
struct EQSettings: Identifiable, Codable, Hashable {
    var id: UUID                      // Unique settings identifier
    var name: String                  // Settings name
    var mode: EQMode                  // EQ mode (graphic/parametric)
    var graphicBands: [GraphicBand]   // Graphic EQ bands
    var parametricBands: [ParametricBand]  // Parametric EQ bands
    var isEnabled: Bool               // Whether EQ is enabled
    
    enum EQMode: String, Codable, CaseIterable {
        case graphic
        case parametric
    }
}
```

#### Static Properties

```swift
static let flat = EQSettings(name: "Flat", mode: .graphic)
```

### GraphicBand

Represents a single band in the graphic EQ.

```swift
struct GraphicBand: Identifiable, Codable, Equatable, Hashable {
    let id: UUID                      // Unique band identifier
    var frequency: Double              // Center frequency in Hz
    var gain: Double                  // Gain in dB (-12 to +12)
    
    static let default10Band: [GraphicBand]  // Pre-configured 10-band setup
}
```

#### Default 10-Band Frequencies

```swift
static let default10Band: [GraphicBand] = [
    GraphicBand(frequency: 31, gain: 0),
    GraphicBand(frequency: 63, gain: 0),
    GraphicBand(frequency: 125, gain: 0),
    GraphicBand(frequency: 250, gain: 0),
    GraphicBand(frequency: 500, gain: 0),
    GraphicBand(frequency: 1000, gain: 0),
    GraphicBand(frequency: 2000, gain: 0),
    GraphicBand(frequency: 4000, gain: 0),
    GraphicBand(frequency: 8000, gain: 0),
    GraphicBand(frequency: 16000, gain: 0)
]
```

### ParametricBand

Represents a single band in the parametric EQ.

```swift
struct ParametricBand: Identifiable, Codable, Equatable, Hashable {
    let id: UUID                      // Unique band identifier
    var frequency: Double              // Center frequency (20-20000 Hz)
    var gain: Double                  // Gain in dB (-20 to +20)
    var q: Double                     // Q factor (0.1-10.0)
    var filterType: FilterType        // Type of filter
    var isEnabled: Bool               // Whether band is active
    
    enum FilterType: String, Codable, CaseIterable {
        case bell        // Bell/peaking filter
        case lowShelf    // Low shelf filter
        case highShelf   // High shelf filter
        case lowPass     // Low pass filter
        case highPass    // High pass filter
    }
}
```

### FrequencyPoint

Represents a single point in a frequency response measurement.

```swift
struct FrequencyPoint: Codable {
    let frequency: Double              // Frequency in Hz
    let amplitude: Double             // Amplitude in dB
}
```

## Audio Engine

### AudioEngineManager

Core audio processing engine that manages device detection, audio routing, and real-time EQ processing.

```swift
class AudioEngineManager: ObservableObject {
    // Published Properties
    @Published var isProcessing = false
    @Published var currentDevice: AudioDevice?
    
    // Initialization
    init()
    
    // Public Methods
    func initialize()                              // Initialize audio engine
    func startProcessing()                         // Start audio processing
    func stopProcessing()                          // Stop audio processing
    func applyEQSettings(_ settings: EQSettings)   // Apply EQ settings
    func startAnalysis()                           // Start spectrum analysis
    func stopAnalysis()                            // Stop spectrum analysis
    func getAvailableDevices() -> [AudioDevice]    // Get available devices
    func getCurrentEQSettings() -> EQSettings      // Get current EQ settings
    func getFrequencyResponse() -> [FrequencyPoint] // Get frequency response
    func cleanup()                                 // Clean up resources
    func switchToDevice(_ device: AudioDevice)     // Switch to device
}
```

#### Usage Example

```swift
let audioEngine = AudioEngineManager()
audioEngine.initialize()
audioEngine.startProcessing()

let settings = EQSettings(name: "Custom", mode: .graphic)
audioEngine.applyEQSettings(settings)
```

## View Models

### AudioEngineViewModel

ViewModel that manages audio engine state and device selection.

```swift
class AudioEngineViewModel: ObservableObject {
    // Published Properties
    @Published var currentDevice: AudioDevice?
    @Published var availableDevices: [AudioDevice] = []
    @Published var isProcessing = false
    @Published var isInitialized = false
    
    // Public Methods
    func initializeAudioEngine()                   // Initialize audio engine
    func loadAvailableDevices()                    // Load available devices
    func switchToDevice(_ device: AudioDevice)     // Switch to device
    func toggleProcessing()                        // Toggle processing state
}
```

### EQViewModel

ViewModel that manages EQ settings and mode switching.

```swift
class EQViewModel: ObservableObject {
    // Published Properties
    @Published var mode: EQMode = .graphic
    @Published var graphicBands: [GraphicBand]
    @Published var parametricBands: [ParametricBand]
    @Published var isEnabled: Bool = true
    
    // Public Methods
    func updateGraphicBand(at index: Int, gain: Double)           // Update graphic band
    func updateParametricBand(at index: Int, frequency: Double?, gain: Double?, 
                              q: Double?, filterType: ParametricBand.FilterType?, 
                              isEnabled: Bool?)                     // Update parametric band
    func resetToFlat()                                             // Reset to flat
    func addParametricBand()                                       // Add parametric band
    func removeParametricBand(at index: Int)                       // Remove parametric band
}
```

### DeviceProfileViewModel

ViewModel that manages device profiles and external data integration.

```swift
class DeviceProfileViewModel: ObservableObject {
    // Published Properties
    @Published var profiles: [DeviceProfile] = []
    @Published var isLoading = false
    @Published var error: String?
    
    // Public Methods
    func loadProfiles()                               // Load profiles
    func addProfile(_ profile: DeviceProfile)         // Add profile
    func deleteProfile(_ profile: DeviceProfile)      // Delete profile
    func updateProfile(_ profile: DeviceProfile)      // Update profile
    func importFromOratory1990()                      // Import from Oratory1990
    func importFromCrinacle()                         // Import from Crinacle
    func exportProfiles() -> URL?                     // Export profiles
    func importProfiles(from url: URL)                // Import profiles
}
```

## Services

### PresetManager

Manages EQ presets with local storage and import/export capabilities.

```swift
class PresetManager {
    // Public Methods
    func savePreset(_ preset: EQSettings)             // Save preset
    func getAllPresets() -> [EQSettings]              // Get all presets
    func deletePreset(_ preset: EQSettings)           // Delete preset
    func updatePreset(_ preset: EQSettings)           // Update preset
    func createPresetFromGraphicBands(_ bands: [GraphicBand], name: String) -> EQSettings  // Create from graphic
    func createPresetFromParametricBands(_ bands: [ParametricBand], name: String) -> EQSettings  // Create from parametric
    func exportPresets() -> URL?                      // Export presets
    func importPresets(from url: URL) -> [EQSettings]? // Import presets
}
```

#### Usage Example

```swift
let presetManager = PresetManager()

// Save preset
let preset = EQSettings(name: "Rock", mode: .graphic)
presetManager.savePreset(preset)

// Get all presets
let presets = presetManager.getAllPresets()

// Export presets
if let url = presetManager.exportPresets() {
    print("Presets exported to: \(url)")
}
```

### DeviceProfileManager

Manages device profiles with local storage and external data integration.

```swift
class DeviceProfileManager {
    // Public Methods
    func saveProfile(_ profile: DeviceProfile)        // Save profile
    func getAllProfiles() -> [DeviceProfile]         // Get all profiles
    func deleteProfile(_ profile: DeviceProfile)      // Delete profile
    func updateProfile(_ profile: DeviceProfile)      // Update profile
    func getProfilesByType(_ type: DeviceProfile.DeviceType) -> [DeviceProfile]  // Get by type
    func searchProfiles(query: String) -> [DeviceProfile]  // Search profiles
}
```

### ExternalDataService

Handles integration with external measurement databases.

```swift
class ExternalDataService {
    // Public Methods
    func fetchOratory1990Data() async throws -> [DeviceProfile]  // Fetch Oratory1990
    func fetchCrinacleData() async throws -> [DeviceProfile]      // Fetch Crinacle
    func parseMeasurementData(from data: Data) throws -> [FrequencyPoint]  // Parse measurements
}
```

### UserPreferencesManager

Manages application settings and user preferences.

```swift
class UserPreferencesManager {
    // Public Methods
    func savePreferences(_ preferences: UserPreferences)  // Save preferences
    func getPreferences() -> UserPreferences              // Get preferences
    func resetToDefaults()                                // Reset to defaults
}
```

## Views

### ContentView

Main application view that orchestrates all UI components.

```swift
struct ContentView: View {
    @StateObject private var audioEngine = AudioEngineViewModel()
    @StateObject private var eqViewModel = EQViewModel()
    @StateObject private var deviceProfileVM = DeviceProfileViewModel()
    
    var body: some View {
        // Main UI layout
    }
}
```

### DeviceSelectorView

Dropdown component for selecting audio devices.

```swift
struct DeviceSelectorView: View {
    @EnvironmentObject var audioEngine: AudioEngineViewModel
    
    var body: some View {
        // Device selection UI
    }
}
```

### GraphicEQView

10-band graphic equalizer interface.

```swift
struct GraphicEQView: View {
    @Binding var bands: [GraphicBand]
    
    var body: some View {
        // Graphic EQ UI with vertical sliders
    }
}
```

### ParametricEQView

Advanced parametric equalizer interface.

```swift
struct ParametricEQView: View {
    @EnvironmentObject var eqViewModel: EQViewModel
    
    var body: some View {
        // Parametric EQ UI with detailed controls
    }
}
```

### SpectrumAnalyzerView

Real-time spectrum analyzer visualization.

```swift
struct SpectrumAnalyzerView: View {
    var body: some View {
        // Spectrum analyzer visualization
    }
}
```

### PresetManagerView

Interface for managing EQ presets and device profiles.

```swift
struct PresetManagerView: View {
    @EnvironmentObject var eqViewModel: EQViewModel
    @EnvironmentObject var deviceProfileVM: DeviceProfileViewModel
    
    var body: some View {
        // Preset management UI
    }
}
```

## Core Audio Components

### AudioDeviceManager

Singleton class that manages Core Audio device detection and monitoring.

```swift
class AudioDeviceManager: ObservableObject {
    static let shared = AudioDeviceManager()
    
    @Published private(set) var devices: [AudioDevice] = []
    @Published private(set) var defaultOutputDevice: AudioDevice?
    
    // Public Methods
    func refreshDevices()                              // Refresh device list
}
```

### EQAudioUnit

Core Audio unit that implements real-time EQ processing.

```swift
class EQAudioUnit {
    let engine: AVAudioEngine
    
    // Public Methods
    init(engine: AVAudioEngine)                        // Initialize
    func insert(after node: AVAudioNode)                // Insert in audio graph
    func applyGraphic(_ bands: [GraphicBand])           // Apply graphic EQ
    func applyParametric(_ bands: [ParametricBand])     // Apply parametric EQ
    func currentSettings() -> EQSettings                // Get current settings
}
```

## Error Handling

### AudioEQError

Custom error types for the application.

```swift
enum AudioEQError: Error, LocalizedError {
    case deviceNotFound
    case audioEngineFailure
    case invalidEQSettings
    case profileImportError
    case presetExportError
    
    var errorDescription: String? {
        // Human-readable error descriptions
    }
}
```

## Notifications

### Notification Names

```swift
extension Notification.Name {
    static let deviceDidChange = Notification.Name("deviceDidChange")
    static let eqSettingsDidChange = Notification.Name("eqSettingsDidChange")
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
}
```

## Constants

### Audio Constants

```swift
struct AudioConstants {
    static let minFrequency: Double = 20.0
    static let maxFrequency: Double = 20000.0
    static let minGain: Double = -20.0
    static let maxGain: Double = 20.0
    static let minQ: Double = 0.1
    static let maxQ: Double = 10.0
}
```

### UI Constants

```swift
struct UIConstants {
    static let minWindowWidth: CGFloat = 800
    static let minWindowHeight: CGFloat = 600
    static let eqViewHeight: CGFloat = 300
    static let spectrumAnalyzerHeight: CGFloat = 200
}
```

---

This API documentation covers all public interfaces of the AudioEQ application. For implementation details, please refer to the source code files.