# AudioEQ User Guide

Welcome to AudioEQ, the professional audio equalizer for macOS! This guide will help you get the most out of your audio experience with our advanced equalization features.

## Table of Contents

- [Getting Started](#getting-started)
- [Interface Overview](#interface-overview)
- [Audio Device Management](#audio-device-management)
- [Graphic Equalizer](#graphic-equalizer)
- [Parametric Equalizer](#parametric-equalizer)
- [Preset Management](#preset-management)
- [Device Profiles](#device-profiles)
- [Spectrum Analyzer](#spectrum-analyzer)
- [Settings and Preferences](#settings-and-preferences)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Troubleshooting](#troubleshooting)
- [Tips and Best Practices](#tips-and-best-practices)

## Getting Started

### Installation

1. Download AudioEQ from the Mac App Store or directly from our website
2. Open the downloaded DMG file
3. Drag AudioEQ to your Applications folder
4. Launch AudioEQ from your Applications folder

### First Launch

When you first launch AudioEQ, you'll be prompted to grant permissions for audio device access. This is required for the app to detect and control your audio devices.

1. Click "Request Permissions" when prompted
2. Open System Preferences > Security & Privacy > Privacy
3. Select "Microphone" and "Audio Device" from the left sidebar
4. Check the box next to AudioEQ to grant permissions
5. Restart AudioEQ

### Basic Setup

1. **Select Your Audio Device**: Use the device selector in the top-right corner to choose your output device
2. **Choose EQ Mode**: Toggle between Graphic and Parametric EQ modes
3. **Start Adjusting**: Use the sliders to shape your sound
4. **Save Your Settings**: Create presets for future use

## Interface Overview

### Main Window Layout

```
┌─────────────────────────────────────────────────────────────┐
│ AudioEQ                           [Device Selector] [⚙] [?] │
├─────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────┐ ┌─────────────────────────────┐ │
│ │ EQ Mode Toggle          │ │      Spectrum Analyzer      │ │
│ ├─────────────────────────┤ ├─────────────────────────────┤ │
│ │                         │ │                             │ │
│ │    EQ Controls          │ │      Preset Manager         │ │
│ │                         │ │                             │ │
│ │                         │ │                             │ │
│ └─────────────────────────┘ └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Key Components

- **Device Selector**: Dropdown menu for selecting audio output devices
- **EQ Mode Toggle**: Switch between Graphic and Parametric EQ modes
- **EQ Controls**: Main equalizer interface (changes based on selected mode)
- **Spectrum Analyzer**: Real-time frequency visualization
- **Preset Manager**: Save, load, and manage EQ presets
- **Settings Button**: Access application preferences
- **Help Button**: Open built-in help documentation

## Audio Device Management

### Selecting Audio Devices

1. Click the device selector dropdown in the top-right corner
2. Choose your preferred output device from the list
3. AudioEQ will automatically switch to the selected device

### Supported Device Types

- **Built-in**: Mac's internal speakers and headphone jack
- **USB**: USB audio interfaces, DACs, and headphones
- **Bluetooth**: Bluetooth headphones and speakers
- **Thunderbolt**: Thunderbolt audio interfaces
- **HDMI**: HDMI audio output (for external displays)

### Device Information

Each device shows:
- Device name and manufacturer
- Connection type (USB, Bluetooth, etc.)
- Number of audio channels
- Supported sample rate

### Automatic Device Detection

AudioEQ automatically detects when devices are:
- Connected (new devices appear in the selector)
- Disconnected (removed from the selector)
- Changed (system default device is highlighted)

## Graphic Equalizer

The Graphic EQ provides 10 fixed frequency bands for quick and intuitive adjustments.

### Frequency Bands

| Band | Frequency | Range | Use Case |
|------|-----------|-------|----------|
| 1 | 31 Hz | Sub-bass | Deep bass, kick drum |
| 2 | 63 Hz | Bass | Bass guitar, low end |
| 3 | 125 Hz | Upper Bass | Low-end warmth |
| 4 | 250 Hz | Low Mids | Body, fullness |
| 5 | 500 Hz | Mids | Vocal presence |
| 6 | 1 kHz | Upper Mids | Clarity, attack |
| 7 | 2 kHz | High Mids | Presence, detail |
| 8 | 4 kHz | Presence | Vocal clarity |
| 9 | 8 kHz | Highs | Sibilance, air |
| 10 | 16 kHz | Ultra-highs | Sparkle, brilliance |

### Using the Graphic EQ

1. **Select Graphic EQ Mode**: Click the "Graphic" button in the EQ mode toggle
2. **Adjust Bands**: Drag sliders up to boost or down to cut frequencies
3. **Fine-tune**: Each slider provides ±12dB of adjustment
4. **Reset**: Click "Reset" to return all bands to flat (0dB)

### Common Graphic EQ Settings

#### Bass Boost
- 31 Hz: +6 dB
- 63 Hz: +4 dB
- 125 Hz: +2 dB

#### Vocal Enhancement
- 500 Hz: +2 dB
- 1 kHz: +3 dB
- 2 kHz: +2 dB
- 4 kHz: +1 dB

#### Treble Boost
- 8 kHz: +4 dB
- 16 kHz: +6 dB

## Parametric Equalizer

The Parametric EQ offers advanced control with configurable frequency, gain, Q factor, and filter types.

### Understanding Parametric EQ Parameters

#### Frequency
- **Range**: 20 Hz - 20 kHz
- **Purpose**: Sets the center frequency for the filter
- **Usage**: Target specific problem frequencies or enhance desired ranges

#### Gain
- **Range**: -20 dB to +20 dB
- **Purpose**: Boosts or cuts the selected frequency
- **Usage**: Positive values boost, negative values cut

#### Q Factor
- **Range**: 0.1 - 10.0
- **Purpose**: Controls the bandwidth of the filter
- **Low Q (0.1-1.0)**: Wide bandwidth, affects broader frequency range
- **High Q (1.0-10.0)**: Narrow bandwidth, affects specific frequencies

#### Filter Types

##### Bell (Peaking)
- **Purpose**: Boosts or cuts around a specific frequency
- **Use Case**: General EQ adjustments, problem frequency correction
- **Example**: Boost 1 kHz by +3 dB with Q=1.0 for vocal presence

##### Low Shelf
- **Purpose**: Adjusts all frequencies below the cutoff point
- **Use Case**: Overall bass control, low-end enhancement
- **Example**: Set at 200 Hz, +3 dB for overall bass warmth

##### High Shelf
- **Purpose**: Adjusts all frequencies above the cutoff point
- **Use Case**: Overall treble control, air and brilliance
- **Example**: Set at 8 kHz, +2 dB for overall brightness

##### Low Pass
- **Purpose**: Allows frequencies below the cutoff point, attenuates above
- **Use Case**: Removing high-frequency noise, warming up sound
- **Note**: Gain control has no effect with this filter type

##### High Pass
- **Purpose**: Allows frequencies above the cutoff point, attenuates below
- **Use Case**: Removing low-frequency rumble, cleaning up mud
- **Note**: Gain control has no effect with this filter type

### Using the Parametric EQ

1. **Select Parametric EQ Mode**: Click the "Parametric" button in the EQ mode toggle
2. **Add Bands**: Click "Add Band" to create new EQ bands (up to 8)
3. **Configure Each Band**:
   - Set the frequency using the slider
   - Adjust gain for boost/cut
   - Set Q factor for bandwidth control
   - Choose filter type
   - Toggle band on/off with the enable switch
4. **Fine-tune**: Make small adjustments and listen to the changes
5. **Reset**: Click "Reset" to return all bands to flat

### Common Parametric EQ Techniques

#### Notch Filter (Problem Frequency Removal)
- **Filter Type**: Bell
- **Frequency**: Problem frequency (e.g., 200 Hz)
- **Gain**: -6 dB (cut)
- **Q Factor**: 5.0 (narrow)

#### Vocal Presence Boost
- **Filter Type**: Bell
- **Frequency**: 2.5 kHz
- **Gain**: +3 dB
- **Q Factor**: 1.5

#### Bass Warmth
- **Filter Type**: Low Shelf
- **Frequency**: 150 Hz
- **Gain**: +2 dB

#### Air Enhancement
- **Filter Type**: High Shelf
- **Frequency**: 10 kHz
- **Gain**: +1.5 dB

## Preset Management

### Saving Presets

1. **Configure Your EQ**: Set up your desired EQ settings
2. **Open Preset Manager**: Click the preset manager panel
3. **Save Preset**: Click "Save Preset" and enter a name
4. **Choose Type**: Select Graphic or Parametric based on your settings

### Loading Presets

1. **Open Preset Manager**: Click the preset manager panel
2. **Browse Presets**: Scroll through your saved presets
3. **Load Preset**: Click on any preset to apply it immediately

### Managing Presets

#### Built-in Presets

AudioEQ includes several built-in presets:
- **Flat**: Neutral, no EQ applied
- **Vocal Boost**: Enhances vocal frequencies
- **Bass Boost**: Increases low-end response
- **Treble Boost**: Enhances high frequencies
- **Rock**: Optimized for rock music
- **Jazz**: Balanced for jazz music
- **Classical**: Enhanced for classical music
- **Electronic**: Optimized for electronic music

#### Custom Presets

Create unlimited custom presets for:
- Different music genres
- Specific headphones or speakers
- Room acoustics
- Personal preferences

#### Import/Export Presets

1. **Export**: Click "Export" to save all presets as a JSON file
2. **Import**: Click "Import" to load presets from a file
3. **Backup**: Regularly export presets for backup
4. **Share**: Export presets to share with others

## Device Profiles

Device profiles contain measurement data and recommended EQ settings for specific audio equipment.

### Integrated Databases

#### Oratory1990
- Community-sourced headphone measurements
- Target EQ curves for neutral sound
- Popular for headphone enthusiasts
- Regular updates with new measurements

#### Crinacle
- Comprehensive headphone and IEM database
- Professional-grade measurements
- Multiple measurement rigs
- Industry-standard reference

#### Custom Profiles
- Create your own profiles from measurements
- Import frequency response data
- Personalized EQ recommendations

### Using Device Profiles

1. **Open Preset Manager**: Click the preset manager panel
2. **Select Profiles Tab**: Switch to device profiles section
3. **Browse Profiles**: Filter by device type or search by name
4. **View Details**: Click on a profile to see frequency response data
5. **Apply EQ**: Click "Apply" to load the recommended EQ settings

### Profile Information

Each profile includes:
- Device specifications (manufacturer, model)
- Measurement data (frequency response)
- Recommended EQ settings
- Source attribution (Oratory1990, Crinacle, etc.)
- Date added to database

### Creating Custom Profiles

1. **Measure Your Device**: Use measurement equipment or software
2. **Import Data**: Load frequency response measurements
3. **Create Profile**: Enter device information
4. **Generate EQ**: Let AudioEQ suggest EQ settings
5. **Fine-tune**: Adjust EQ to your preference

## Spectrum Analyzer

The spectrum analyzer provides real-time visual feedback of your audio's frequency content.

### Understanding the Display

- **X-Axis**: Frequency (20 Hz to 20 kHz, logarithmic scale)
- **Y-Axis**: Amplitude (loudness in decibels)
- **Color Coding**: Different colors for different frequency ranges
- **Real-time Updates**: Continuously displays current audio output

### Using the Spectrum Analyzer

1. **Toggle Display**: Use ⌘+/ or the toggle button to show/hide
2. **Play Audio**: Start music or audio to see the spectrum
3. **Analyze Peaks**: Watch for frequency buildup or gaps
4. **Correlate with EQ**: See how your EQ changes affect the spectrum

### Frequency Color Coding

- **Red**: Low frequencies (20-250 Hz)
- **Orange**: Low-mid frequencies (250-500 Hz)
- **Yellow**: Mid frequencies (500-2 kHz)
- **Green**: High-mid frequencies (2-8 kHz)
- **Blue**: High frequencies (8-20 kHz)

### Practical Uses

#### Identifying Problem Frequencies
- Look for consistently high peaks that may cause harshness
- Identify frequency gaps that may need boosting
- Monitor overall frequency balance

#### EQ Verification
- See how your EQ changes affect the frequency spectrum
- Verify that your adjustments are having the intended effect
- Fine-tune EQ settings while watching real-time feedback

## Settings and Preferences

Access settings by clicking the gear icon (⚙) in the top-right corner.

### Audio Settings

#### Buffer Size
- **Small**: Lower latency, higher CPU usage
- **Medium**: Balance of latency and CPU usage
- **Large**: Higher latency, lower CPU usage

#### Sample Rate
- **44.1 kHz**: CD quality, standard for most music
- **48 kHz**: Standard for video and digital audio
- **96 kHz**: High-resolution audio
- **192 kHz**: Ultra-high-resolution audio

### Interface Settings

#### Theme
- **Light**: Light color scheme
- **Dark**: Dark color scheme
- **System**: Follows system appearance settings

#### Window Behavior
- **Remember window position**: Save window location
- **Always on top**: Keep window above other apps
- **Minimize to menu bar**: Minimize to menu bar instead of Dock

### Performance Settings

#### Spectrum Analyzer
- **Update rate**: How often the display refreshes
- **Resolution**: Frequency resolution of the analysis
- **Color scheme**: Visual appearance of the spectrum

#### CPU Usage
- **Priority**: Audio processing priority
- **Multi-core**: Use multiple CPU cores if available

### Data Management

#### Automatic Backups
- **Enable**: Automatically backup presets and profiles
- **Frequency**: How often to create backups
- **Location**: Where to store backup files

#### External Data
- **Auto-update**: Automatically update device profiles
- **Cache size**: Limit cached measurement data
- **Refresh rate**: How often to check for updates

## Keyboard Shortcuts

Master these shortcuts to work more efficiently:

### EQ Controls
- `⌘+,` - Reset EQ to flat
- `⌘+.` - Toggle EQ on/off
- `⌘+S` - Save current EQ settings as preset
- `⌘+O` - Open preset manager

### Interface
- `⌘+/` - Toggle spectrum analyzer
- `⌘+R` - Refresh device list
- `⌘+P` - Switch to previous device
- `⌘+N` - Switch to next device

### EQ Mode
- `⌘+1` - Switch to Graphic EQ mode
- `⌘+2` - Switch to Parametric EQ mode

### Presets
- `⌘+↑` - Select previous preset
- `⌘+↓` - Select next preset
- `⌘+→` - Apply selected preset
- `⌘+←` - Load selected preset for editing

### Window
- `⌘+W` - Close window (minimize to menu bar)
- `⌘+M` - Minimize to Dock
- `⌘+Q` - Quit application

## Troubleshooting

### Common Issues

#### No Sound After Applying EQ
1. Check that your device is selected correctly
2. Verify that EQ is enabled (toggle switch)
3. Check system volume levels
4. Try resetting EQ to flat
5. Restart audio processing (⌘+R)

#### Distortion or Poor Sound Quality
1. Reduce extreme EQ settings (±12dB or more)
2. Check for clipping in the spectrum analyzer
3. Lower overall system volume
4. Try a different buffer size in settings
5. Reset EQ to flat and start over

#### Device Not Detected
1. Verify device is connected and powered on
2. Check audio permissions in System Preferences
3. Refresh device list (⌘+R)
4. Disconnect and reconnect the device
5. Restart AudioEQ

#### High CPU Usage
1. Increase buffer size in settings
2. Disable spectrum analyzer if not needed
3. Close other audio applications
4. Reduce the number of active EQ bands
5. Restart the application

#### Application Crashes
1. Reset preferences to defaults
2. Clear cache in settings
3. Reinstall the application
4. Report the issue with crash logs

### Performance Optimization

#### For Best Performance
- Use appropriate buffer size (start with Medium)
- Disable spectrum analyzer if not needed
- Keep EQ settings reasonable (avoid extreme boosts/cuts)
- Close unused applications
- Keep your Mac's software updated

#### For Lowest Latency
- Use smallest buffer size
- Disable spectrum analyzer
- Use wired connections when possible
- Close background applications
- Restart audio processing before critical listening

## Tips and Best Practices

### EQ Techniques

#### Start with Flat
Always begin with a flat EQ and make gradual adjustments. This helps you understand what each change does.

#### Use Reference Tracks
Compare your EQ settings with well-mixed commercial tracks in the same genre.

#### Less is More
Small adjustments (1-3 dB) often have more impact than large changes.

#### Trust Your Ears
Use measurements and visualizations as guides, but always trust what sounds best to you.

#### Take Breaks
Your ears can fatigue. Take regular breaks when fine-tuning EQ settings.

### Preset Management

#### Organize by Use Case
Create presets for different scenarios:
- Music genres (Rock, Jazz, Classical)
- Content types (Music, Movies, Games)
- Environments (Quiet, Noisy, Studio)
- Devices (Headphones, Speakers, Car)

#### Backup Regularly
Export your presets regularly to avoid losing your custom settings.

#### Share with Others
Export your favorite presets to share with friends or the community.

### Device Profiles

#### Use Measurements as Starting Points
Device profiles provide excellent starting points, but personal preference matters.

#### Consider Room Acoustics
Remember that room acoustics affect sound, especially with speakers.

#### Update Regularly
Keep your device profiles updated for the latest measurements.

### Advanced Usage

#### A/B Testing
Use the EQ toggle to quickly compare EQ on/off for the same audio.

#### Match Levels
When comparing EQ settings, try to match perceived loudness levels.

#### Document Your Settings
Take notes on what settings work best for different situations.

---

## Need More Help?

- **Built-in Help**: Click the question mark (?) button in the app
- **Online Support**: Visit our website at www.audioeq.com/support
- **Community Forum**: Join discussions at forum.audioeq.com
- **Email Support**: Contact us at support@audioeq.com

Enjoy your enhanced audio experience with AudioEQ! 🎵