//
//  HelpView.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // Getting Started
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Getting Started")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        HelpSection(title: "Welcome to AudioEQ", content: """
                            AudioEQ is a professional audio equalizer for macOS that provides advanced audio processing capabilities with both graphic and parametric EQ modes, device-specific presets, and integration with headphone measurement databases.
                            """)
                        
                        HelpSection(title: "Basic Usage", content: """
                            1. Select your audio output device from the dropdown in the top-right corner
                            2. Choose between Graphic EQ (10-band) or Parametric EQ modes
                            3. Adjust the EQ sliders to shape your sound
                            4. Save your settings as presets for future use
                            5. Browse device profiles for popular headphones and speakers
                            """)
                        
                        HelpSection(title: "Keyboard Shortcuts", content: """
                            • ⌘+S: Save current EQ settings as preset
                            • ⌘+O: Open preset manager
                            • ⌘+,: Reset EQ to flat
                            • ⌘+.: Toggle EQ on/off
                            • ⌘+/: Toggle spectrum analyzer
                            """)
                    }
                    .padding()
                }
                .tabItem {
                    Label("Getting Started", systemImage: "play.circle")
                }
                .tag(0)
                
                // EQ Modes
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("EQ Modes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        HelpSection(title: "Graphic EQ", content: """
                        The Graphic EQ provides 10 fixed frequency bands at standard octave intervals:
                        • 31Hz, 63Hz, 125Hz, 250Hz, 500Hz
                        • 1kHz, 2kHz, 4kHz, 8kHz, 16kHz
                        
                        Each band provides ±20dB of gain adjustment. This mode is ideal for quick adjustments and general purpose equalization.
                        """)
                        
                        HelpSection(title: "Parametric EQ", content: """
                        The Parametric EQ offers advanced control with up to 8 configurable bands:
                        • Frequency: 20Hz - 20kHz range
                        • Gain: ±20dB adjustment range
                        • Q Factor: 0.1 - 10.0 (bandwidth control)
                        • Filter Types: Bell, Low Shelf, High Shelf, Low Pass, High Pass
                        
                        This mode provides precise control for professional audio engineering and critical listening.
                        """)
                        
                        HelpSection(title: "Filter Types", content: """
                        • Bell: Boosts or cuts around a specific frequency
                        • Low Shelf: Adjusts all frequencies below the cutoff point
                        • High Shelf: Adjusts all frequencies above the cutoff point
                        • Low Pass: Allows frequencies below the cutoff point
                        • High Pass: Allows frequencies above the cutoff point
                        """)
                    }
                    .padding()
                }
                .tabItem {
                    Label("EQ Modes", systemImage: "slider.horizontal.3")
                }
                .tag(1)
                
                // Device Profiles
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Device Profiles")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        HelpSection(title: "Integrated Databases", content: """
                        AudioEQ integrates with industry-standard headphone measurement databases:
                        
                        • Oratory1990: Reddit-based community measurements with target EQ curves
                        • Crinacle: Comprehensive headphone and IEM measurements
                        • Custom: Create your own profiles from measurements
                        """)
                        
                        HelpSection(title: "Using Profiles", content: """
                        1. Browse profiles by device type (Headphone, IEM, Studio Monitor, etc.)
                        2. Search by manufacturer or model name
                        3. Click "Apply" to load the recommended EQ settings
                        4. Profiles include frequency response data and target curves
                        5. Create custom profiles for your specific devices
                        """)
                        
                        HelpSection(title: "Measurement Data", content: """
                        Device profiles include:
                        • Frequency response measurements (20Hz - 20kHz)
                        • Recommended target EQ settings
                        • Compensation curves for neutral sound
                        • Source attribution (Oratory1990, Crinacle, etc.)
                        """)
                    }
                    .padding()
                }
                .tabItem {
                    Label("Device Profiles", systemImage: "headphones")
                }
                .tag(2)
                
                // Advanced
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Advanced Features")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        HelpSection(title: "Spectrum Analyzer", content: """
                        The real-time spectrum analyzer provides visual feedback:
                        • 64-band frequency analysis
                        • Color-coded frequency bands
                        • Real-time amplitude display
                        • Helps identify frequency buildup and issues
                        • Useful for understanding EQ effects
                        """)
                        
                        HelpSection(title: "Audio Engine", content: """
                        AudioEQ uses Core Audio for professional-grade processing:
                        • Low-latency audio routing
                        • 32-bit floating-point processing
                        • Real-time parameter updates
                        • Sample rate support up to 192kHz
                        • Automatic device detection and switching
                        """)
                        
                        HelpSection(title: "Presets Management", content: """
                        • Save unlimited custom presets
                        • Import/export preset collections
                        • Share presets between devices
                        • Backup your EQ settings
                        • Organize by use case (music, movies, games)
                        """)
                    }
                    .padding()
                }
                .tabItem {
                    Label("Advanced", systemImage: "gearshape.2")
                }
                .tag(3)
                
                // Troubleshooting
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Troubleshooting")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        
                        HelpSection(title: "Common Issues", content: """
                        • No sound: Check device selection and system volume
                        • Distortion: Reduce extreme EQ settings
                        • Latency: Restart audio processing
                        • Device not found: Check audio permissions
                        • Crashes: Reset preferences to defaults
                        """)
                        
                        HelpSection(title: "Performance Tips", content: """
                        • Close unused applications for better performance
                        • Use appropriate buffer sizes in settings
                        • Disable spectrum analyzer if not needed
                        • Reset EQ to flat when not in use
                        • Keep audio drivers updated
                        """)
                        
                        HelpSection(title: "Permissions", content: """
                        AudioEQ requires these permissions:
                        • Microphone Access: For audio analysis
                        • Audio Device Access: For device control
                        • Files Access: For importing/exporting presets
                        
                        Grant permissions in System Preferences > Security & Privacy
                        """)
                    }
                    .padding()
                }
                .tabItem {
                    Label("Troubleshooting", systemImage: "exclamationmark.triangle")
                }
                .tag(4)
            }
            .navigationTitle("Help")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct HelpSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(content)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
            .frame(width: 700, height: 600)
    }
}