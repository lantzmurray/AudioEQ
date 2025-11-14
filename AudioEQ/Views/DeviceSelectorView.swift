//
//  DeviceSelectorView.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

struct DeviceSelectorView: View {
    @EnvironmentObject var audioEngine: AudioEngineViewModel
    @State private var isDropdownOpen = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Output Device")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Menu {
                ForEach(audioEngine.availableDevices) { device in
                    Button(action: {
                        audioEngine.switchToDevice(device)
                    }) {
                        HStack {
                            Image(systemName: deviceIcon(for: device.deviceType))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(device.name)
                                    .font(.body)
                                Text("\(device.manufacturer) • \(device.channels) channels")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if audioEngine.currentDevice?.id == device.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    if let currentDevice = audioEngine.currentDevice {
                        Image(systemName: deviceIcon(for: currentDevice.deviceType))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(currentDevice.name)
                                .font(.body)
                            Text(currentDevice.manufacturer)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("No Device Selected")
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isDropdownOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                )
            }
            .onTapGesture {
                isDropdownOpen.toggle()
            }
        }
        .frame(width: 250)
    }
    
    private func deviceIcon(for type: AudioDevice.DeviceType) -> String {
        switch type {
        case .builtIn:
            return "speaker.wave.3"
        case .usb:
            return "cable.connector"
        case .bluetooth:
            return "antenna.radiowaves.left.and.right"
        case .thunderbolt:
            return "bolt"
        case .hdmi:
            return "tv"
        case .other:
            return "speaker.2"
        }
    }
}

struct DeviceSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSelectorView()
            .environmentObject(AudioEngineViewModel())
            .frame(width: 300, height: 100)
    }
}