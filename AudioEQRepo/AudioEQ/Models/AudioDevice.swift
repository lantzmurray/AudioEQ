//
//  AudioDevice.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation
import CoreAudio
import AVFoundation

// Make sure AudioDeviceID exists in this module
typealias AudioDeviceID = UInt32

struct AudioDevice: Identifiable, Equatable, Codable, Hashable {
    typealias ID = UInt32

    let id: UInt32
    let name: String
    let manufacturer: String
    let uid: String
    let deviceType: DeviceType
    let channels: Int
    let sampleRate: Double

    enum DeviceType: String, CaseIterable, Codable {
        case builtIn = "Built-in"
        case usb = "USB"
        case bluetooth = "Bluetooth"
        case thunderbolt = "Thunderbolt"
        case hdmi = "HDMI"
        case other = "Other"
    }
}

extension AudioDevice {
    static let example = AudioDevice(
        id: 1,
        name: "Built-in Output",
        manufacturer: "Apple",
        uid: "AppleHDAEngineOutput:1B,0,1,0:1",
        deviceType: .builtIn,
        channels: 2,
        sampleRate: 44100.0
    )
}
