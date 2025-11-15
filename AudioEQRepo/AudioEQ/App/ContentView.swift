//
//  ContentView.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var audioEngine = AudioEngineViewModel()
    @StateObject private var eqViewModel = EQViewModel()
    @StateObject private var deviceProfileVM = DeviceProfileViewModel()
    @State private var showingSettings = false
    @State private var showingHelp = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with device selector and settings
            HStack {
                Text("AudioEQ")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 16) {
                    DeviceSelectorView()
                        .environmentObject(audioEngine)
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .font(.title3)
                    }
                    .buttonStyle(.borderless)
                    .help("Settings")
                    
                    Button(action: {
                        showingHelp = true
                    }) {
                        Image(systemName: "questionmark.circle")
                            .font(.title3)
                    }
                    .buttonStyle(.borderless)
                    .help("Help")
                }
            }
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            Divider()
            
            // Main content area
            HStack(spacing: 20) {
                // Left panel - EQ controls
                VStack(spacing: 16) {
                    // EQ mode toggle
                    EQModeToggle()
                        .environmentObject(eqViewModel)
                    
                    // EQ interface
                    TabView(selection: $eqViewModel.mode) {
                        GraphicEQView(bands: $eqViewModel.graphicBands)

                            .tag(EQMode.graphic)
                            .environmentObject(eqViewModel)
                        
                        ParametricEQView()
                            .tag(EQMode.parametric)
                            .environmentObject(eqViewModel)
                    }
                    .frame(height: 300)
                }
                .frame(maxWidth: .infinity)
                
                // Right panel - spectrum analyzer and presets
                VStack(spacing: 16) {
                    // Spectrum analyzer
                    SpectrumAnalyzerView()
                        .frame(height: 200)
                    
                    // Preset manager
                    PresetManagerView()
                        .environmentObject(eqViewModel)
                        .environmentObject(deviceProfileVM)
                }
                .frame(width: 300)
            }
            .padding()
        }
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            audioEngine.initializeAudioEngine()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .frame(width: 500, height: 600)
        }
        .sheet(isPresented: $showingHelp) {
            HelpView()
                .frame(width: 700, height: 600)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
