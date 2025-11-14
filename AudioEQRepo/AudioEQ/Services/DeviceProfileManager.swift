//
//  DeviceProfileManager.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation

class DeviceProfileManager {
    private let userDefaults = UserDefaults.standard
    private let profilesKey = "DeviceProfiles"
    
    func saveProfile(_ profile: DeviceProfile) {
        var profiles = getAllProfiles()
        
        // Remove existing profile with same ID if it exists
        profiles.removeAll { $0.id == profile.id }
        
        // Add the new profile
        profiles.append(profile)
        
        saveProfiles(profiles)
    }
    
    func getAllProfiles() -> [DeviceProfile] {
        guard let data = userDefaults.data(forKey: profilesKey),
              let profiles = try? JSONDecoder().decode([DeviceProfile].self, from: data) else {
            return getDefaultProfiles()
        }
        return profiles
    }
    
    func getLocalProfiles() -> [DeviceProfile] {
        return getAllProfiles().filter { $0.dataSource == .local || $0.dataSource == .custom }
    }
    
    func deleteProfile(_ profile: DeviceProfile) {
        var profiles = getAllProfiles()
        profiles.removeAll { $0.id == profile.id }
        saveProfiles(profiles)
    }
    
    func updateProfile(_ profile: DeviceProfile) {
        var profiles = getAllProfiles()
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
            saveProfiles(profiles)
        }
    }
    
    func saveProfiles(_ profiles: [DeviceProfile]) {
        guard let data = try? JSONEncoder().encode(profiles) else { return }
        userDefaults.set(data, forKey: profilesKey)
    }
    
    private func getDefaultProfiles() -> [DeviceProfile] {
        return [
            DeviceProfile.example,
            DeviceProfile.airpodsPro,
            DeviceProfile(
                name: "Sony WH-1000XM4",
                manufacturer: "Sony",
                model: "WH-1000XM4",
                deviceType: .headphone,
                frequencyResponse: [
                    FrequencyPoint(frequency: 20, amplitude: -3.2),
                    FrequencyPoint(frequency: 100, amplitude: -1.5),
                    FrequencyPoint(frequency: 1000, amplitude: 2.1),
                    FrequencyPoint(frequency: 5000, amplitude: 4.2),
                    FrequencyPoint(frequency: 10000, amplitude: -1.8),
                    FrequencyPoint(frequency: 20000, amplitude: -10.5)
                ],
                recommendedEQ: EQSettings(name: "Sony WH-1000XM4 Target"),
                dataSource: .crinacle
            ),
            DeviceProfile(
                name: "Beyerdynamic DT 990 Pro",
                manufacturer: "Beyerdynamic",
                model: "DT 990 Pro",
                deviceType: .studioMonitor,
                frequencyResponse: [
                    FrequencyPoint(frequency: 20, amplitude: -1.2),
                    FrequencyPoint(frequency: 100, amplitude: 0.8),
                    FrequencyPoint(frequency: 1000, amplitude: 1.5),
                    FrequencyPoint(frequency: 5000, amplitude: 3.8),
                    FrequencyPoint(frequency: 10000, amplitude: 2.1),
                    FrequencyPoint(frequency: 20000, amplitude: -5.2)
                ],
                recommendedEQ: EQSettings(name: "DT 990 Pro Target"),
                dataSource: .oratory1990
            )
        ]
    }
    
    func exportProfiles() -> URL? {
        let profiles = getAllProfiles()
        guard let data = try? JSONEncoder().encode(profiles) else { return nil }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("AudioEQ_DeviceProfiles.json")
        
        try? data.write(to: fileURL)
        return fileURL
    }
    
    func importProfiles(from url: URL) -> [DeviceProfile]? {
        guard let data = try? Data(contentsOf: url),
              let profiles = try? JSONDecoder().decode([DeviceProfile].self, from: data) else {
            return nil
        }
        
        var existingProfiles = getAllProfiles()
        existingProfiles.append(contentsOf: profiles)
        saveProfiles(existingProfiles)
        
        return profiles
    }
    
    func searchProfiles(query: String) -> [DeviceProfile] {
        let allProfiles = getAllProfiles()
        
        if query.isEmpty {
            return allProfiles
        }
        
        return allProfiles.filter { profile in
            profile.name.localizedCaseInsensitiveContains(query) ||
            profile.manufacturer.localizedCaseInsensitiveContains(query) ||
            profile.model.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getProfilesByType(_ type: DeviceProfile.DeviceType) -> [DeviceProfile] {
        return getAllProfiles().filter { $0.deviceType == type }
    }
    
    func getProfilesBySource(_ source: DeviceProfile.DataSource) -> [DeviceProfile] {
        return getAllProfiles().filter { $0.dataSource == source }
    }
}

// Extension to make DeviceProfile codable work properly
extension DeviceProfile {
    enum CodingKeys: String, CodingKey {
        case id, name, manufacturer, model, deviceType, frequencyResponse, recommendedEQ, dataSource, dateAdded
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(manufacturer, forKey: .manufacturer)
        try container.encode(model, forKey: .model)
        try container.encode(deviceType, forKey: .deviceType)
        try container.encode(frequencyResponse, forKey: .frequencyResponse)
        try container.encode(recommendedEQ, forKey: .recommendedEQ)
        try container.encode(dataSource, forKey: .dataSource)
        try container.encode(dateAdded, forKey: .dateAdded)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        manufacturer = try container.decode(String.self, forKey: .manufacturer)
        model = try container.decode(String.self, forKey: .model)
        deviceType = try container.decode(DeviceType.self, forKey: .deviceType)
        frequencyResponse = try container.decode([FrequencyPoint].self, forKey: .frequencyResponse)
        recommendedEQ = try container.decode(EQSettings.self, forKey: .recommendedEQ)
        dataSource = try container.decode(DataSource.self, forKey: .dataSource)
        dateAdded = try container.decode(Date.self, forKey: .dateAdded)
    }
}