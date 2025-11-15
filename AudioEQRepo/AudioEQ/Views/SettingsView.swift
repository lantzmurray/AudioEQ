//
//  SettingsView.swift
//  AudioEQ
//

import SwiftUI
import AppKit

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
                        Task { await updateExternalData() }
                    }
                }
                
                Section("Data Management") {
                    Button("Export Preferences") { exportPreferences() }
                    Button("Import Preferences") { importPreferences() }
                    Button("Reset to Defaults") { resetPreferences() }
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .frame(minWidth: 500, minHeight: 550)
    }
    
    // MARK: - Actions

    private func updateExternalData() async {
        preferences.markExternalDataUpdated()
    }
    
    private func exportPreferences() {
        if let url = preferences.exportPreferences() {
            let alert = NSAlert()
            alert.messageText = "Preferences Exported"
            alert.informativeText = "Preferences exported to:\n\(url.path)"
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    private func importPreferences() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            let success = preferences.importPreferences(from: url)
            let alert = NSAlert()
            alert.messageText = success ? "Import Successful" : "Import Failed"
            alert.informativeText = success
                ? "Preferences have been imported and applied."
                : "Could not import preferences from the selected file."
            alert.alertStyle = success ? .informational : .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    private func resetPreferences() {
        let alert = NSAlert()
        alert.messageText = "Reset Preferences?"
        alert.informativeText = "This will reset all preferences to default values. This action cannot be undone."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Reset")
        
        if alert.runModal() == .alertSecondButtonReturn {
            preferences.resetToDefaults()
            let done = NSAlert()
            done.messageText = "Reset Complete"
            done.informativeText = "All preferences have been restored."
            done.alertStyle = .informational
            done.addButton(withTitle: "OK")
            done.runModal()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .frame(width: 500, height: 600)
    }
}
