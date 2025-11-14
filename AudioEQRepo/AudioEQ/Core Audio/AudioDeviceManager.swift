//
//  AudioDeviceManager.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation
import CoreAudio
import AVFoundation

class AudioDeviceManager: ObservableObject {
    @Published var availableDevices: [AudioDevice] = []
    @Published var currentDevice: AudioDevice?
    
    private var deviceChangeListener: AudioObjectPropertyListenerProc?
    
    init() {
        setupDeviceChangeListener()
        refreshDeviceList()
    }
    
    deinit {
        removeDeviceChangeListener()
    }
    
    func refreshDeviceList() {
        var devices: [AudioDevice] = []
        
        // Get output devices
        let outputDevices = getAudioDevices(isOutput: true)
        
        for deviceID in outputDevices {
            if let device = createAudioDevice(from: deviceID) {
                devices.append(device)
            }
        }
        
        DispatchQueue.main.async {
            self.availableDevices = devices
            
            // Set current device if not already set
            if self.currentDevice == nil, let defaultDevice = devices.first {
                self.currentDevice = defaultDevice
            }
        }
    }
    
    func setCurrentDevice(_ device: AudioDevice) {
        var error = OSStatus(noErr)
        
        // Set default output device
        var deviceID = device.id
        error = AudioObjectSetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            kAudioObjectPropertyScopeGlobal,
            kAudioObjectPropertyElementMaster,
            kAudioHardwarePropertyDefaultOutputDevice,
            &deviceID,
            UInt32(MemoryLayout<AudioDeviceID>.size)
        )
        
        if error == noErr {
            DispatchQueue.main.async {
                self.currentDevice = device
            }
        } else {
            print("Failed to set default output device: \(error)")
        }
    }
    
    private func getAudioDevices(isOutput: Bool) -> [AudioDeviceID] {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        var dataSize: UInt32 = 0
        var status = AudioObjectGetPropertyDataSize(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            &dataSize
        )
        
        guard status == noErr else { return [] }
        
        let deviceIDs = UnsafeMutablePointer<AudioDeviceID>.allocate(capacity: Int(dataSize) / MemoryLayout<AudioDeviceID>.size)
        defer { deviceIDs.deallocate() }
        
        status = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            &dataSize,
            deviceIDs
        )
        
        guard status == noErr else { return [] }
        
        let deviceCount = Int(dataSize) / MemoryLayout<AudioDeviceID>.size
        var validDevices: [AudioDeviceID] = []
        
        for i in 0..<deviceCount {
            let deviceID = deviceIDs[i]
            
            if isOutputDevice(deviceID) == isOutput {
                validDevices.append(deviceID)
            }
        }
        
        return validDevices
    }
    
    private func isOutputDevice(_ deviceID: AudioDeviceID) -> Bool {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreams,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        var dataSize: UInt32 = 0
        var status = AudioObjectGetPropertyDataSize(
            deviceID,
            &propertyAddress,
            &dataSize
        )
        
        guard status == noErr else { return false }
        
        // If there are output streams, it's an output device
        return dataSize > 0
    }
    
    private func createAudioDevice(from deviceID: AudioDeviceID) -> AudioDevice? {
        let name = getDeviceName(deviceID)
        let manufacturer = getDeviceManufacturer(deviceID)
        let uid = getDeviceUID(deviceID)
        let deviceType = getDeviceType(deviceID)
        let channels = getDeviceChannels(deviceID)
        let sampleRate = getDeviceSampleRate(deviceID)
        
        guard let deviceName = name,
              let deviceManufacturer = manufacturer,
              let deviceUID = uid else {
            return nil
        }
        
        return AudioDevice(
            id: deviceID,
            name: deviceName,
            manufacturer: deviceManufacturer,
            uid: deviceUID,
            deviceType: deviceType,
            channels: channels,
            sampleRate: sampleRate
        )
    }
    
    private func getDeviceName(_ deviceID: AudioDeviceID) -> String? {
        return getStringProperty(deviceID, kAudioDevicePropertyDeviceName, kAudioDevicePropertyScopeOutput)
    }
    
    private func getDeviceManufacturer(_ deviceID: AudioDeviceID) -> String? {
        return getStringProperty(deviceID, kAudioDevicePropertyDeviceManufacturer, kAudioDevicePropertyScopeOutput)
    }
    
    private func getDeviceUID(_ deviceID: AudioDeviceID) -> String? {
        return getStringProperty(deviceID, kAudioDevicePropertyDeviceUID, kAudioDevicePropertyScopeOutput)
    }
    
    private func getDeviceType(_ deviceID: AudioDeviceID) -> AudioDevice.DeviceType {
        let transportType = getTransportType(deviceID)
        
        switch transportType {
        case kAudioDeviceTransportTypeBuiltIn:
            return .builtIn
        case kAudioDeviceTransportTypeUSB:
            return .usb
        case kAudioDeviceTransportTypeBluetooth:
            return .bluetooth
        case kAudioDeviceTransportTypeThunderbolt:
            return .thunderbolt
        case kAudioDeviceTransportTypeHDMI:
            return .hdmi
        default:
            return .other
        }
    }
    
    private func getTransportType(_ deviceID: AudioDeviceID) -> UInt32 {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyTransportType,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        var transportType: UInt32 = 0
        var dataSize = UInt32(MemoryLayout<UInt32>.size)
        
        let status = AudioObjectGetPropertyData(
            deviceID,
            &propertyAddress,
            &dataSize,
            &transportType
        )
        
        return status == noErr ? transportType : 0
    }
    
    private func getDeviceChannels(_ deviceID: AudioDeviceID) -> Int {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyPreferredChannelsForStereo,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        var channels: [Int32] = [0, 0]
        var dataSize = UInt32(channels.count * MemoryLayout<Int32>.size)
        
        let status = AudioObjectGetPropertyData(
            deviceID,
            &propertyAddress,
            &dataSize,
            &channels
        )
        
        return status == noErr ? Int(channels[0]) : 2
    }
    
    private func getDeviceSampleRate(_ deviceID: AudioDeviceID) -> Double {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyNominalSampleRate,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        var sampleRate: Double = 44100.0
        var dataSize = UInt32(MemoryLayout<Double>.size)
        
        let status = AudioObjectGetPropertyData(
            deviceID,
            &propertyAddress,
            &dataSize,
            &sampleRate
        )
        
        return status == noErr ? sampleRate : 44100.0
    }
    
    private func getStringProperty(_ deviceID: AudioDeviceID, _ selector: AudioObjectPropertySelector, _ scope: AudioObjectPropertyScope) -> String? {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: selector,
            mScope: scope,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        var dataSize: UInt32 = 0
        var status = AudioObjectGetPropertyDataSize(deviceID, &propertyAddress, &dataSize)
        guard status == noErr else { return nil }
        
        let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: Int(dataSize))
        defer { buffer.deallocate() }
        
        status = AudioObjectGetPropertyData(deviceID, &propertyAddress, &dataSize, buffer)
        guard status == noErr else { return nil }
        
        return String(cString: buffer)
    }
    
    private func setupDeviceChangeListener() {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        deviceChangeListener = { (objectID, numAddresses, addresses, clientData) -> OSStatus in
            guard let addresses = addresses else { return noErr }
            
            for i in 0..<numAddresses {
                if addresses[i].mSelector == kAudioHardwarePropertyDevices {
                    // Device list changed, refresh
                    DispatchQueue.main.async {
                        (clientData.assumingMemoryBound(to: AudioDeviceManager.self).pointee).refreshDeviceList()
                    }
                    break
                }
            }
            
            return noErr
        }
        
        AudioObjectAddPropertyListener(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            deviceChangeListener!,
            Unmanaged.passUnretained(self).toOpaque()
        )
    }
    
    private func removeDeviceChangeListener() {
        guard let listener = deviceChangeListener else { return }
        
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMaster
        )
        
        AudioObjectRemovePropertyListener(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            listener,
            Unmanaged.passUnretained(self).toOpaque()
        )
    }
}