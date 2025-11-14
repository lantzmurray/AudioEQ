# AudioEQ - Professional Audio Equalizer for macOS

AudioEQ is a native macOS application that provides advanced audio equalization capabilities with both graphic and parametric EQ modes, device-specific presets, and integration with headphone measurement databases.

## Features

- **Dual EQ Modes**: Both 10-band graphic and parametric EQ
- **Device Profiles**: Integration with Oratory1990 and Crinacle measurement databases
- **Real-time Processing**: Low-latency audio using Core Audio
- **Preset System**: Save/load EQ settings for different devices
- **Spectrum Analyzer**: Visual feedback for EQ adjustments
- **Device Management**: Automatic audio device detection and switching

## Project Structure

```
AudioEQ/
├── AudioEQ.xcodeproj              # Xcode project file
├── AudioEQ/
│   ├── App/                        # Main application entry point
│   │   ├── AudioEQApp.swift         # App delegate and main window
│   │   └── ContentView.swift         # Main UI view
│   ├── Models/                      # Data models
│   │   ├── AudioDevice.swift          # Audio device representation
│   │   ├── DeviceProfile.swift       # Device profile with frequency response
│   │   └── EQSettings.swift         # EQ settings and configurations
│   ├── Views/                       # SwiftUI views
│   │   ├── DeviceSelectorView.swift   # Audio device picker
│   │   ├── EQModeToggle.swift        # EQ mode switcher
│   │   ├── GraphicEQView.swift       # 10-band graphic EQ interface
│   │   ├── ParametricEQView.swift    # Parametric EQ interface
│   │   ├── PresetManagerView.swift   # Preset and profile management
│   │   └── SpectrumAnalyzerView.swift # Real-time spectrum display
│   ├── ViewModels/                  # MVVM view models
│   │   ├── AudioEngineViewModel.swift # Audio engine state management
│   │   ├── DeviceProfileViewModel.swift # Device profile management
│   │   └── EQViewModel.swift         # EQ settings management
│   ├── Services/                    # Business logic and services
│   │   ├── AudioEngineManager.swift   # Core Audio engine wrapper
│   │   ├── DeviceProfileManager.swift # Local profile storage
│   │   ├── ExternalDataService.swift  # External data integration
│   │   └── PresetManager.swift     # Preset storage and management
│   ├── Core Audio/                  # Audio processing components
│   ├── Resources/                    # App resources and assets
│   │   └── Info.plist              # App configuration
│   └── Extensions/                  # Swift extensions
└── AudioEQTests/                    # Unit tests
```

## Getting Started

### Prerequisites

- macOS 12.0 (Monterey) or later
- Xcode 14.0 or later
- Swift 5.7+

### Installation

1. Clone or download the project
2. Open `AudioEQ.xcodeproj` in Xcode
3. Build and run the application

### Development Setup

1. **Audio Permissions**: The app requires microphone and audio device access permissions
2. **Code Signing**: Set up your developer team in project settings
3. **Entitlements**: Ensure proper audio device access entitlements

## Architecture

### MVVM Pattern

The application follows the Model-View-ViewModel (MVVM) architecture:

- **Models**: Data structures and business logic
- **Views**: SwiftUI interface components
- **ViewModels**: State management and data binding

### Core Audio Integration

- **AVAudioEngine**: Main audio processing engine
- **AVAudioUnitEQ**: Real-time equalization
- **AudioDeviceManager**: Device detection and management

### Data Persistence

- **UserDefaults**: Simple settings and presets
- **JSON Serialization**: Import/export functionality
- **External APIs**: Oratory1990 and Crinacle integration

## Key Components

### Audio Engine Manager

Handles real-time audio processing and device management:

```swift
let audioEngine = AudioEngineManager()
audioEngine.initialize()
audioEngine.startProcessing()
audioEngine.applyEQSettings(eqSettings)
```

### EQ Settings

Supports both graphic and parametric EQ modes:

```swift
let graphicEQ = EQSettings(name: "Rock", mode: .graphic)
let parametricEQ = EQSettings(name: "Custom", mode: .parametric)
```

### Device Profiles

Integrates with measurement databases:

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

## External Data Integration

### Oratory1990 Integration

- Source: Reddit posts and GitHub repository
- Format: Frequency response measurements + recommended EQ
- Implementation: Async data fetching and parsing

### Crinacle Integration

- Source: Public measurement database
- Format: Various measurement formats (CSV, JSON)
- Implementation: API calls and static data import

## Testing

### Unit Tests

- Audio processing algorithms
- EQ filter calculations
- Data model validation

### Integration Tests

- Device detection and switching
- Real-time audio processing
- External API integration

### UI Tests

- User interaction flows
- Control responsiveness
- Accessibility compliance

## Performance Considerations

### Audio Latency

- Use appropriate buffer sizes
- High-priority audio threads
- Efficient DSP algorithms

### UI Performance

- SwiftUI optimizations
- Lazy loading for device profiles
- Efficient spectrum analyzer rendering

## Distribution

### Mac App Store

- Code signing certificate
- App Store Connect setup
- Sandbox compliance
- Privacy policy

### Direct Distribution

- Developer ID certificate
- Notarization
- Installer package

## Contributing

1. Fork the repository
2. Create a feature branch
3. Implement changes with tests
4. Submit a pull request

## License

Copyright © 2025 AudioEQ. All rights reserved.

## Support

For issues and feature requests, please use the GitHub issue tracker.