//
//  DeviceProfile.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation

struct DeviceProfile: Identifiable, Codable {
    let id: UUID
    let name: String
    let manufacturer: String
    let model: String
    let deviceType: DeviceType
    let frequencyResponse: [FrequencyPoint]
    let recommendedEQ: EQSettings
    let dataSource: DataSource
    let dateAdded: Date
    
    enum DeviceType: String, CaseIterable, Codable {
        case headphone = "Headphone"
        case inEar = "In-Ear Monitor"
        case studioMonitor = "Studio Monitor"
        case speaker = "Speaker"
        case earbud = "Earbud"
    }
    
    enum DataSource: String, CaseIterable, Codable {
        case local = "Local"
        case oratory1990 = "Oratory1990"
        case crinacle = "Crinacle"
        case custom = "Custom"
    }
    
    init(name: String, manufacturer: String, model: String, deviceType: DeviceType, 
         frequencyResponse: [FrequencyPoint] = [], recommendedEQ: EQSettings = EQSettings.flat, 
         dataSource: DataSource = .local) {
        self.id = UUID()
        self.name = name
        self.manufacturer = manufacturer
        self.model = model
        self.deviceType = deviceType
        self.frequencyResponse = frequencyResponse
        self.recommendedEQ = recommendedEQ
        self.dataSource = dataSource
        self.dateAdded = Date()
    }
}

struct FrequencyPoint: Identifiable, Codable {
    let id = UUID()
    let frequency: Double
    let amplitude: Double // in dB
    
    init(frequency: Double, amplitude: Double) {
        self.frequency = frequency
        self.amplitude = amplitude
    }
}

extension DeviceProfile {
    static let example = DeviceProfile(
        name: "HD 600",
        manufacturer: "Sennheiser",
        model: "HD 600",
        deviceType: .headphone,
        frequencyResponse: [
            FrequencyPoint(frequency: 20, amplitude: -2.1),
            FrequencyPoint(frequency: 100, amplitude: -1.8),
            FrequencyPoint(frequency: 1000, amplitude: 0.5),
            FrequencyPoint(frequency: 5000, amplitude: 2.1),
            FrequencyPoint(frequency: 10000, amplitude: -1.2),
            FrequencyPoint(frequency: 20000, amplitude: -8.5)
        ],
        recommendedEQ: EQSettings(name: "HD 600 Target"),
        dataSource: .oratory1990
    )
    
    static let airpodsPro = DeviceProfile(
        name: "AirPods Pro",
        manufacturer: "Apple",
        model: "AirPods Pro",
        deviceType: .inEar,
        frequencyResponse: [
            FrequencyPoint(frequency: 20, amplitude: -5.2),
            FrequencyPoint(frequency: 100, amplitude: 2.1),
            FrequencyPoint(frequency: 1000, amplitude: 1.8),
            FrequencyPoint(frequency: 5000, amplitude: 3.2),
            FrequencyPoint(frequency: 10000, amplitude: -2.1),
            FrequencyPoint(frequency: 20000, amplitude: -12.5)
        ],
        recommendedEQ: EQSettings(name: "AirPods Pro Target"),
        dataSource: .crinacle
    )
}