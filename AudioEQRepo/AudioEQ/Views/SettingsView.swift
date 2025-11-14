//
//  SettingsView.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var preferences = UserPreferencesManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("General") {
                    Toggle("Auto-start audio processing", isOn: $preferences.autoStartProcessing)
                    Toggle("Show spectrum analyzer", isOn: $preferences.showSpectrumAnalyzer)
                    
                    Picker("Default EQ Mode", selection: $preferences.defaultEQMode) {
                        ForEach(EQMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                }
                
                Section("Device") {
                    if let deviceID = preferences.selectedDeviceID {
                        Text("Selected Device ID: \(deviceID)")
                            .foregroundColor(.secondary)
                    } else {
                        Text("No device selected")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Updates") {
                    Toggle("Check for updates", isOn: $preferences.checkForUpdates)
                    Toggle("Enable notifications", isOn: $preferences.enableNotifications)
                    
                    if let lastUpdate = preferences.lastExternalDataUpdate {
                        Text("Last data update: \(lastUpdate, style: .date)")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Update External Data Now") {
                        Task {
                            await updateExternalData()
                        }
                    }
                }
                
                Section("Data Management") {
                    Button("Export Preferences") {
                        exportPreferences()
                    }
                    
                    Button("Import Preferences") {
                        importPreferences()
                    }
                    
                    Button("Reset to Defaults") {
                        resetPreferences()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func updateExternalData() async {
        // This would trigger the external data update
        print("Updating external data...")
        preferences.markExternalDataUpdated()
    }
    
    private func exportPreferences() {
        if let url = preferences.exportPreferences() {
            print("Preferences exported to: \(url.path)")
            
            // Show save panel or notification
            let alert = NSAlert()
            alert.messageText = "Preferences exported successfully"
            alert.informativeTextWithFormat = "File saved to: \(url.path)"
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    private func importPreferences() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        panel.title = "Import Preferences"
        
        if panel.runModal() == .OK, let url = panel.url {
            if preferences.importPreferences(from: url) {
                print("Preferences imported successfully")
                
                let alert = NSAlert()
                alert.messageText = "Import Successful"
                alert.informativeText = "Preferences have been imported and applied."
                alert.alertStyle = .informational
                alert.addButton(withTitle: "OK")
                alert.runModal()
            } else {
                let alert = NSAlert()
                alert.messageText = "Import Failed"
                alert.informativeText = "Could not import preferences from the selected file."
                alert.alertStyle = .critical
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
    }
    
    private func resetPreferences() {
        let alert = NSAlert()
        alert.messageText = "Reset Preferences"
        alert.informativeText = "This will reset all preferences to their default values. This action cannot be undone."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Reset") { _ in
            preferences.resetToDefaults()
            
            let confirmAlert = NSAlert()
            confirmAlert.messageText = "Reset Complete"
            confirmAlert.informativeText = "All preferences have been reset to defaults."
            confirmAlert.alertStyle = .informational
            confirmAlert.addButton(withTitle: "OK")
            confirmAlert.runModal()
        }
        alert.runModal()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .frame(width: 500, height: 600)
    }
}