//
//  PresetManagerView.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

struct PresetManagerView: View {
    @EnvironmentObject var eqViewModel: EQViewModel
    @EnvironmentObject var deviceProfileVM: DeviceProfileViewModel
    @State private var showingSavePresetDialog = false
    @State private var presetName = ""
    @State private var selectedPreset: EQSettings?
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Presets & Profiles")
                    .font(.headline)
                
                Spacer()
                
                Button("Save Preset") {
                    showingSavePresetDialog = true
                }
                .buttonStyle(.bordered)
            }
            
            // Tab view for presets and device profiles
            TabView {
                // EQ Presets tab
                PresetListView(
                    presets: eqViewModel.getAllPresets(),
                    selectedPreset: $selectedPreset,
                    onLoadPreset: { preset in
                        eqViewModel.loadPreset(preset)
                    },
                    onDeletePreset: { preset in
                        eqViewModel.deletePreset(preset)
                    }
                )
                .tabItem {
                    Label("EQ Presets", systemImage: "slider.horizontal.3")
                }
                
                // Device Profiles tab
                DeviceProfileListView(
                    profiles: deviceProfileVM.deviceProfiles,
                    selectedProfile: deviceProfileVM.selectedProfile,
                    onSelectProfile: { profile in
                        deviceProfileVM.selectProfile(profile)
                        deviceProfileVM.applyProfileToEQ(profile, eqViewModel: eqViewModel)
                    }
                )
                .tabItem {
                    Label("Device Profiles", systemImage: "headphones")
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .sheet(isPresented: $showingSavePresetDialog) {
            SavePresetDialog(
                presetName: $presetName,
                onSave: { name in
                    eqViewModel.savePreset(name: name)
                    presetName = ""
                }
            )
        }
    }
}

struct PresetListView: View {
    let presets: [EQSettings]
    @Binding var selectedPreset: EQSettings?
    let onLoadPreset: (EQSettings) -> Void
    let onDeletePreset: (EQSettings) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(presets) { preset in
                    PresetRow(
                        preset: preset,
                        isSelected: selectedPreset?.id == preset.id,
                        onLoad: {
                            onLoadPreset(preset)
                            selectedPreset = preset
                        },
                        onDelete: {
                            onDeletePreset(preset)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct DeviceProfileListView: View {
    let profiles: [DeviceProfile]
    let selectedProfile: DeviceProfile?
    let onSelectProfile: (DeviceProfile) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(profiles) { profile in
                    DeviceProfileRow(
                        profile: profile,
                        isSelected: selectedProfile?.id == profile.id,
                        onSelect: {
                            onSelectProfile(profile)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PresetRow: View {
    let preset: EQSettings
    let isSelected: Bool
    let onLoad: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(preset.name)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .regular)
                
                Text(preset.mode.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
            
            Button(action: onLoad) {
                Text("Load")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.caption)
            }
            .buttonStyle(.borderless)
            .foregroundColor(.red)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
        )
    }
}

struct DeviceProfileRow: View {
    let profile: DeviceProfile
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(profile.name)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .regular)
                
                Text("\(profile.manufacturer) \(profile.model)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(profile.deviceType.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                    
                    Text(profile.dataSource.rawValue)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
            
            Button(action: onSelect) {
                Text("Apply")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
        )
    }
}

struct SavePresetDialog: View {
    @Binding var presetName: String
    let onSave: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Save EQ Preset")
                .font(.headline)
            
            TextField("Preset Name", text: $presetName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Save") {
                    if !presetName.isEmpty {
                        onSave(presetName)
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(presetName.isEmpty)
            }
        }
        .padding(20)
        .frame(width: 300)
    }
}

struct PresetManagerView_Previews: PreviewProvider {
    static var previews: some View {
        PresetManagerView()
            .environmentObject(EQViewModel())
            .environmentObject(DeviceProfileViewModel())
            .frame(width: 350, height: 300)
    }
}