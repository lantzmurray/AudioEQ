//
//  AudioDeviceManager.swift
//  AudioEQ
//

import Foundation
import CoreAudio
import AVFoundation

class AudioDeviceManager: ObservableObject {
    static let shared = AudioDeviceManager()

    @Published private(set) var devices: [AudioDevice] = []
    @Published private(set) var defaultOutputDevice: AudioDevice?

    private init() {
        refreshDevices()
        registerForDeviceNotifications()
    }

    // MARK: - Device Refresh
    func refreshDevices() {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        var dataSize: UInt32 = 0
        AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject),
                                       &propertyAddress,
                                       0,
                                       nil,
                                       &dataSize)

        let deviceCount = Int(dataSize) / MemoryLayout<AudioDeviceID>.size
        var deviceIDs = [AudioDeviceID](repeating: 0, count: deviceCount)

        AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                                   &propertyAddress,
                                   0,
                                   nil,
                                   &dataSize,
                                   &deviceIDs)

        var newDevices: [AudioDevice] = []

        for id in deviceIDs {
            if let device = getDeviceInfo(id) {
                newDevices.append(device)
            }
        }

        devices = newDevices
        defaultOutputDevice = getDefaultOutputDevice()
    }

    // MARK: - Device Info
    private func getDeviceInfo(_ deviceID: AudioDeviceID) -> AudioDevice? {
        var name: CFString = "" as CFString
        var manufacturer: CFString = "" as CFString
        var uid: CFString = "" as CFString

        func readString(_ selector: AudioObjectPropertySelector, into value: inout CFString) {
            var address = AudioObjectPropertyAddress(
                mSelector: selector,
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: kAudioObjectPropertyElementMain
            )
            var dataSize = UInt32(MemoryLayout<CFString>.size)
            AudioObjectGetPropertyData(deviceID, &address, 0, nil, &dataSize, &value)
        }

        readString(kAudioObjectPropertyName, into: &name)
        readString(kAudioObjectPropertyManufacturer, into: &manufacturer)
        readString(kAudioDevicePropertyDeviceUID, into: &uid)

        let isOutput = supportsOutput(deviceID)
        let channels = getChannelCount(deviceID)
        let sampleRate = getSampleRate(deviceID)

        return AudioDevice(
            id: deviceID,
            name: name as String,
            manufacturer: manufacturer as String,
            uid: uid as String,
            deviceType: isOutput ? .usb : .other,   // You can refine this later
            channels: channels,
            sampleRate: sampleRate
        )
    }

    private func supportsOutput(_ deviceID: AudioDeviceID) -> Bool {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreamConfiguration,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        var dataSize: UInt32 = 0
        AudioObjectGetPropertyDataSize(deviceID, &address, 0, nil, &dataSize)

        let bufferList = UnsafeMutablePointer<AudioBufferList>.allocate(capacity: Int(dataSize))
        defer { bufferList.deallocate() }

        AudioObjectGetPropertyData(deviceID, &address, 0, nil, &dataSize, bufferList)
        return bufferList.pointee.mNumberBuffers > 0
    }

    private func getChannelCount(_ deviceID: AudioDeviceID) -> Int {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreamConfiguration,
            mScope: kAudioDevicePropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )
        var dataSize: UInt32 = 0
        AudioObjectGetPropertyDataSize(deviceID, &address, 0, nil, &dataSize)

        let bufferList = UnsafeMutablePointer<AudioBufferList>.allocate(capacity: Int(dataSize))
        defer { bufferList.deallocate() }

        AudioObjectGetPropertyData(deviceID, &address, 0, nil, &dataSize, bufferList)
        return Int(bufferList.pointee.mBuffers.mNumberChannels)
    }

    private func getSampleRate(_ deviceID: AudioDeviceID) -> Double {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyNominalSampleRate,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var sampleRate: Double = 0
        var dataSize = UInt32(MemoryLayout<Double>.size)
        AudioObjectGetPropertyData(deviceID, &address, 0, nil, &dataSize, &sampleRate)
        return sampleRate
    }

    private func getDefaultOutputDevice() -> AudioDevice? {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var deviceID: AudioDeviceID = 0
        var dataSize = UInt32(MemoryLayout<AudioDeviceID>.size)
        AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                                   &address,
                                   0, nil,
                                   &dataSize,
                                   &deviceID)
        return getDeviceInfo(deviceID)
    }

    // MARK: - Notification
    private func registerForDeviceNotifications() {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        AudioObjectAddPropertyListenerBlock(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            DispatchQueue.main
        ) { (_, _) in
            self.refreshDevices()
        }
    }
}

