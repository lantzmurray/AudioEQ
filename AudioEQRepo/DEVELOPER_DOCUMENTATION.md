# AudioEQ Developer Documentation

This documentation is intended for developers who want to contribute to the AudioEQ project, understand its architecture, or extend its functionality.

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Development Environment Setup](#development-environment-setup)
- [Project Structure](#project-structure)
- [Core Components](#core-components)
- [Data Flow](#data-flow)
- [Audio Processing Pipeline](#audio-processing-pipeline)
- [Building and Testing](#building-and-testing)
- [Contributing Guidelines](#contributing-guidelines)
- [Code Style and Conventions](#code-style-and-conventions)
- [Performance Considerations](#performance-considerations)
- [Debugging and Troubleshooting](#debugging-and-troubleshooting)
- [Extension Points](#extension-points)
- [Release Process](#release-process)

## Architecture Overview

### MVVM Architecture

AudioEQ follows the Model-View-ViewModel (MVVM) architectural pattern:

```
┌─────────────────────────────────────────────────────────────┐
│                        View Layer                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │
│  │   Views     │  │   Views     │  │       Views         │   │
│  │ (SwiftUI)   │  │ (SwiftUI)   │  │     (SwiftUI)       │   │
│  └─────────────┘  └─────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    ViewModel Layer                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │
│  │AudioEngineVM│  │  EQViewModel│  │DeviceProfileVM      │   │
│  └─────────────┘  └─────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Model Layer                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐   │
│  │   Models    │  │  Services   │  │   Core Audio        │   │
│  └─────────────┘  └─────────────┘  └─────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Principles

1. **Separation of Concerns**: Each layer has distinct responsibilities
2. **Data Binding**: SwiftUI's data binding connects Views to ViewModels
3. **Observable Pattern**: ViewModels use `@Published` properties for state changes
4. **Dependency Injection**: Services are injected into ViewModels
5. **Reactive Programming**: Combine framework handles asynchronous operations

## Development Environment Setup

### Prerequisites

- macOS 12.0 (Monterey) or later
- Xcode 14.0 or later
- Swift 5.7+
- Git for version control
- Apple Developer account (for code signing)

### Initial Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/AudioEQ.git
   cd AudioEQ
   ```

2. **Open in Xcode**:
   ```bash
   open AudioEQ.xcodeproj
   ```

3. **Configure Development Team**:
   - Select the AudioEQ project in the navigator
   - Choose your development team in the "Signing & Capabilities" tab
   - Ensure "Automatically manage signing" is checked

4. **Install Dependencies**:
   ```bash
   # No external dependencies currently used
   # Future dependencies will be managed via Swift Package Manager
   ```

### Development Configuration

1. **Debug Configuration**:
   - Enable "Debug executable" in scheme settings
   - Set breakpoints in key methods
   - Enable "Address Sanitizer" for memory debugging

2. **Testing Configuration**:
   - Create separate test scheme
   - Configure test target with appropriate settings
   - Enable code coverage for test runs

## Project Structure

### Directory Organization

```
AudioEQ/
├── App/                        # Application entry point
│   ├── AudioEQApp.swift         # Main app delegate
│   └── ContentView.swift         # Primary UI view
├── Models/                      # Data models and structures
│   ├── AudioDevice.swift          # Device representation
│   ├── DeviceProfile.swift       # Profile with measurements
│   ├── EQSettings.swift         # EQ configurations
│   ├── GraphicBand.swift         # Graphic EQ band data
│   ├── ParametricBand.swift      # Parametric EQ band data
│   └── FrequencyPoint.swift      # Frequency response data
├── Views/                       # SwiftUI interface components
│   ├── DeviceSelectorView.swift   # Device picker
│   ├── EQModeToggle.swift        # Mode switcher
│   ├── GraphicEQView.swift       # 10-band EQ interface
│   ├── ParametricEQView.swift    # Advanced EQ interface
│   ├── PresetManagerView.swift   # Preset/profile manager
│   ├── SpectrumAnalyzerView.swift # Real-time spectrum display
│   ├── SettingsView.swift         # Preferences
│   └── HelpView.swift            # Documentation
├── ViewModels/                  # MVVM view models
│   ├── AudioEngineViewModel.swift # Audio engine state
│   ├── DeviceProfileViewModel.swift # Profile management
│   └── EQViewModel.swift         # EQ settings state
├── Services/                    # Business logic and services
│   ├── AudioEngineManager.swift   # Core Audio wrapper
│   ├── DeviceProfileManager.swift # Profile storage
│   ├── ExternalDataService.swift  # External data integration
│   ├── PresetManager.swift     # Preset storage and management
│   └── UserPreferencesManager.swift # Settings management
├── Core Audio/                  # Audio processing components
│   ├── AudioDeviceManager.swift # Device detection
│   └── EQAudioUnit.swift       # EQ processing
├── Resources/                    # App resources and assets
│   └── Info.plist              # App configuration
└── Extensions/                  # Swift extensions
```

### Naming Conventions

- **Files**: PascalCase (e.g., `AudioDeviceManager.swift`)
- **Classes/Structs**: PascalCase (e.g., `AudioDeviceManager`)
- **Properties/Methods**: camelCase (e.g., `currentDevice`)
- **Constants**: Upper snake case (e.g., `MAX_GAIN_DB`)
- **Extensions**: Group related functionality in separate files

## Core Components

### Audio Engine

#### AudioEngineManager

The central component for audio processing:

```swift
class AudioEngineManager: ObservableObject {
    // Core audio components
    private var audioEngine: AVAudioEngine?
    private var eqAudioUnit: EQAudioUnit?
    private var deviceManager: AudioDeviceManager?
    
    // Published state
    @Published var isProcessing = false
    @Published var currentDevice: AudioDevice?
}
```

**Key Responsibilities**:
- Initialize and configure AVAudioEngine
- Manage audio graph connections
- Handle device switching
- Apply EQ settings in real-time
- Coordinate with Core Audio system

#### EQAudioUnit

Custom AudioUnit for EQ processing:

```swift
class EQAudioUnit {
    let engine: AVAudioEngine
    private var eqNode: AVAudioUnitEQ?
    
    func insert(after node: AVAudioNode)
    func applyGraphic(_ bands: [GraphicBand])
    func applyParametric(_ bands: [ParametricBand])
}
```

### Device Management

#### AudioDeviceManager

Singleton for Core Audio device detection:

```swift
class AudioDeviceManager: ObservableObject {
    static let shared = AudioDeviceManager()
    
    @Published private(set) var devices: [AudioDevice] = []
    @Published private(set) var defaultOutputDevice: AudioDevice?
}
```

**Implementation Details**:
- Uses Core Audio's AudioObjectPropertyAddress API
- Registers for device change notifications
- Handles device hot-plugging/unplugging
- Provides device information caching

### Data Models

#### EQSettings

Core data structure for EQ configurations:

```swift
struct EQSettings: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var mode: EQMode
    var graphicBands: [GraphicBand]
    var parametricBands: [ParametricBand]
    var isEnabled: Bool
}
```

**Design Considerations**:
- Codable for JSON serialization
- Identifiable for SwiftUI lists
- Hashable for Set operations
- Mutable properties for editing

## Data Flow

### EQ Settings Application Flow

```
User Input (Slider)
        │
        ▼
ViewModel (EQViewModel)
        │
        ▼
Service (AudioEngineManager)
        │
        ▼
Core Audio (EQAudioUnit)
        │
        ▼
Audio Output
```

### Device Detection Flow

```
Core Audio System Event
        │
        ▼
AudioDeviceManager (Singleton)
        │
        ▼
Notification (Published)
        │
        ▼
AudioEngineViewModel
        │
        ▼
UI Update (DeviceSelector)
```

### Preset Management Flow

```
User Action (Save/Load)
        │
        ▼
PresetManager (Service)
        │
        ▼
UserDefaults/JSON File
        │
        ▼
EQViewModel (Update)
        │
        ▼
UI Refresh
```

## Audio Processing Pipeline

### Audio Graph Architecture

```
Input Source → PlayerNode → MixerNode → EQAudioUnit → MainMixer → OutputNode
```

### Real-time Processing

1. **Audio Input**: Captured from system audio or input device
2. **Buffer Processing**: Processed in configurable buffer sizes
3. **EQ Application**: Digital signal processing applied
4. **Output**: Sent to selected output device

### DSP Implementation

#### Graphic EQ

Uses AVAudioUnitEQ with fixed frequency bands:

```swift
let eqNode = AVAudioUnitEQ(numberOfBands: 10)
for (index, band) in graphicBands.enumerated() {
    let eqBand = eqNode.bands[index]
    eqBand.frequency = Float(band.frequency)
    eqBand.gain = Float(band.gain)
    eqBand.filterType = .parametric
    eqBand.bandwidth = 1.0  // Octave bandwidth
}
```

#### Parametric EQ

Configurable filters with precise control:

```swift
let eqBand = eqNode.bands[index]
eqBand.frequency = Float(band.frequency)
eqBand.gain = Float(band.gain)
eqBand.bandwidth = Float(band.q)
eqBand.filterType = mapFilterType(band.filterType)
eqBand.bypass = !band.isEnabled
```

## Building and Testing

### Build Configurations

#### Debug Build
- Full debug symbols
- Assertions enabled
- No optimization
- Development provisioning

#### Release Build
- Stripped debug symbols
- Assertions disabled
- Full optimization
- Distribution provisioning

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme AudioEQ -destination 'platform=macOS'

# Run specific test class
xcodebuild test -scheme AudioEQ -destination 'platform=macOS' -only-testing:AudioEQTests/AudioEngineTests

# Run with code coverage
xcodebuild test -scheme AudioEQ -destination 'platform=macOS' -enableCodeCoverage YES
```

### Test Structure

```
AudioEQTests/
├── AudioEngineTests/           # Audio engine unit tests
├── ModelTests/                 # Model validation tests
├── ServiceTests/               # Service layer tests
├── UITests/                    # UI automation tests
└── IntegrationTests/           # End-to-end tests
```

### Performance Testing

#### Audio Latency Measurement

```swift
func measureAudioLatency() -> TimeInterval {
    // Implement round-trip latency measurement
    // Use Core Audio timestamp APIs
    // Return measured latency in seconds
}
```

#### CPU Usage Profiling

1. Use Instruments app with Time Profiler
2. Measure CPU usage during active EQ processing
3. Identify performance bottlenecks
4. Optimize critical code paths

## Contributing Guidelines

### Pull Request Process

1. **Fork the Repository**: Create a personal fork
2. **Create Feature Branch**: `git checkout -b feature/amazing-feature`
3. **Implement Changes**: Follow code style and testing guidelines
4. **Add Tests**: Ensure test coverage for new functionality
5. **Update Documentation**: Update relevant documentation files
6. **Submit PR**: Create pull request with detailed description

### Code Review Checklist

- [ ] Code follows project conventions
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No performance regressions
- [ ] No memory leaks or retain cycles
- [ ] Proper error handling
- [ ] UI accessibility considerations

### Issue Reporting

When reporting bugs, include:
- macOS version
- AudioEQ version
- Steps to reproduce
- Expected vs actual behavior
- System audio configuration
- Console logs if applicable

## Code Style and Conventions

### Swift Style Guide

#### Naming

```swift
// Classes/Structs: PascalCase
class AudioDeviceManager { }

// Properties/Methods: camelCase
var currentDevice: AudioDevice?
func refreshDevices() { }

// Constants: Upper snake case
let MAX_GAIN_DB: Double = 20.0
```

#### Access Control

```swift
// Public API
public class AudioEngineManager: ObservableObject {
    @Published public var isProcessing = false
    
    // Internal implementation
    private var audioEngine: AVAudioEngine?
    
    // Public interface
    public func startProcessing() { }
}
```

#### Error Handling

```swift
enum AudioEQError: Error, LocalizedError {
    case deviceNotFound
    case audioEngineFailure
    
    var errorDescription: String? {
        switch self {
        case .deviceNotFound:
            return "Audio device not found"
        case .audioEngineFailure:
            return "Failed to initialize audio engine"
        }
    }
}
```

### SwiftUI Conventions

#### View Structure

```swift
struct GraphicEQView: View {
    @Binding var bands: [GraphicBand]
    
    var body: some View {
        // View implementation
    }
}

struct GraphicEQView_Previews: PreviewProvider {
    static var previews: some View {
        GraphicEQView(bands: .constant(GraphicBand.default10Band))
    }
}
```

#### State Management

```swift
class EQViewModel: ObservableObject {
    @Published var mode: EQMode = .graphic
    @Published var graphicBands: [GraphicBand] = []
    
    private var cancellables = Set<AnyCancellable>()
}
```

## Performance Considerations

### Audio Thread Priority

```swift
// High priority for audio processing
let audioQueue = DispatchQueue(label: "com.audioeq.audio", qos: .userInteractive)
```

### Memory Management

#### Avoid Retain Cycles

```swift
class AudioEngineManager: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        deviceManager?.$defaultOutputDevice
            .sink { [weak self] device in  // Use weak self
                self?.currentDevice = device
            }
            .store(in: &cancellables)
    }
}
```

#### Resource Cleanup

```swift
deinit {
    stopProcessing()
    audioEngine?.stop()
    cancellables.removeAll()
}
```

### UI Performance

#### Efficient Updates

```swift
// Batch UI updates
DispatchQueue.main.async {
    self.isProcessing = true
    self.currentDevice = device
}
```

#### Lazy Loading

```swift
// Lazy loading for large datasets
LazyVStack {
    ForEach(profiles.indices, id: \.self) { index in
        ProfileRow(profile: profiles[index])
    }
}
```

## Debugging and Troubleshooting

### Common Issues

#### Audio Engine Not Starting

1. Check system audio permissions
2. Verify device availability
3. Check for other audio apps conflicts
4. Reset audio session

#### Memory Leaks

1. Use Instruments Leaks tool
2. Check for retain cycles in closures
3. Verify proper cleanup in deinit
4. Monitor memory usage during long runs

#### UI Not Updating

1. Verify @Published properties
2. Check @StateObject vs @ObservedObject usage
3. Ensure main thread UI updates
4. Verify Combine subscriptions

### Debugging Tools

#### Console Logging

```swift
// Debug logging with context
enum LogLevel {
    case debug, info, warning, error
}

func log(_ message: String, level: LogLevel = .debug) {
    #if DEBUG
    print("[AudioEQ][\(level)] \(message)")
    #endif
}
```

#### Performance Profiling

1. Use Instruments app
2. Time Profiler for CPU usage
3. Allocations for memory tracking
4. Leaks for memory leak detection

## Extension Points

### Custom Filter Types

```swift
extension ParametricBand.FilterType {
    case allPass
    case notch
    case bandPass
}
```

### External Data Sources

```swift
protocol ExternalDataSource {
    func fetchDeviceProfiles() async throws -> [DeviceProfile]
    func validateProfile(_ profile: DeviceProfile) -> Bool
}
```

### Custom UI Components

```swift
protocol EQControl {
    associatedtype ValueType
    var value: ValueType { get set }
    var onValueChanged: ((ValueType) -> Void)? { get set }
}
```

## Release Process

### Version Management

#### Semantic Versioning

- **Major**: Breaking changes
- **Minor**: New features (backward compatible)
- **Patch**: Bug fixes (backward compatible)

#### Build Numbers

Format: `MAJOR.MINOR.PATCH.BUILD`
- Increment build for each release candidate
- Reset build for each minor version

### Release Checklist

#### Pre-Release

- [ ] All tests passing
- [ ] Performance benchmarks met
- [ ] Documentation updated
- [ ] Change log updated
- [ ] Version numbers updated
- [ ] Code signing configured
- [ ] Notarization setup

#### Release

1. **Create Release Branch**: `git checkout -b release/v1.2.0`
2. **Update Version**: Update Info.plist and project settings
3. **Build Archive**: Create distribution build
4. **Test Archive**: Verify release build
5. **Notarize**: Submit for Apple notarization
6. **Create Tag**: `git tag v1.2.0`
7. **Merge to Main**: Merge release branch
8. **Create Release**: GitHub release with notes

#### Post-Release

- [ ] Update documentation
- [ ] Monitor crash reports
- [ ] Address user feedback
- [ ] Plan next release

### Distribution Channels

#### Mac App Store

1. Prepare app metadata
2. Create app record in App Store Connect
3. Upload build via Xcode Organizer
4. Submit for review
5. Release upon approval

#### Direct Distribution

1. Create Developer ID certificate
2. Build and notarize app
3. Create installer package
4. Host on website
5. Update download links

---

## Additional Resources

### Documentation

- [Apple Core Audio Documentation](https://developer.apple.com/documentation/coreaudio)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Combine Framework](https://developer.apple.com/documentation/combine/)

### Tools

- [Instruments](https://developer.apple.com/xcode/instruments/)
- [Audio Units](https://developer.apple.com/documentation/audiounits)
- [Core Audio Utilities](https://github.com/apple/oss-fuzz/tree/master/projects/coreaudio)

### Community

- [Apple Developer Forums](https://developer.apple.com/forums/)
- [Swift Community](https://swift.org/community/)
- [Audio Engineering Society](https://www.aes.org/)

---

For questions or contributions, please refer to the project's GitHub repository or contact the development team.