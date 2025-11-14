//
//  DeviceProfileViewModel.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation
import Combine

class DeviceProfileViewModel: ObservableObject {
    @Published var deviceProfiles: [DeviceProfile] = []
    @Published var selectedProfile: DeviceProfile?
    @Published var isLoading = false
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let deviceProfileManager = DeviceProfileManager()
    private let externalDataService = ExternalDataService()
    
    init() {
        loadDeviceProfiles()
        
        // Filter profiles based on search text
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterProfiles(searchText)
            }
            .store(in: &cancellables)
    }
    
    private func loadDeviceProfiles() {
        isLoading = true
        
        // Load local profiles first
        deviceProfiles = deviceProfileManager.getLocalProfiles()
        
        // Load external profiles in background
        Task {
            await loadExternalProfiles()
        }
        
        isLoading = false
    }
    
    @MainActor
    private func loadExternalProfiles() async {
        do {
            let oratoryProfiles = try await externalDataService.fetchOratory1990Data()
            let crinacleProfiles = try await externalDataService.fetchCrinacleData()
            
            deviceProfiles.append(contentsOf: oratoryProfiles)
            deviceProfiles.append(contentsOf: crinacleProfiles)
            
            // Save to local cache
            deviceProfileManager.saveProfiles(oratoryProfiles + crinacleProfiles)
        } catch {
            print("Error loading external profiles: \(error)")
        }
    }
    
    private func filterProfiles(_ searchText: String) {
        if searchText.isEmpty {
            loadDeviceProfiles()
        } else {
            deviceProfiles = deviceProfiles.filter { profile in
                profile.name.localizedCaseInsensitiveContains(searchText) ||
                profile.manufacturer.localizedCaseInsensitiveContains(searchText) ||
                profile.model.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func selectProfile(_ profile: DeviceProfile) {
        selectedProfile = profile
    }
    
    func applyProfileToEQ(_ profile: DeviceProfile, eqViewModel: EQViewModel) {
        eqViewModel.loadPreset(profile.recommendedEQ)
    }
    
    func createCustomProfile(name: String, manufacturer: String, model: String, 
                           deviceType: DeviceProfile.DeviceType, 
                           frequencyResponse: [FrequencyPoint] = [],
                           recommendedEQ: EQSettings = .flat) -> DeviceProfile {
        let profile = DeviceProfile(
            name: name,
            manufacturer: manufacturer,
            model: model,
            deviceType: deviceType,
            frequencyResponse: frequencyResponse,
            recommendedEQ: recommendedEQ,
            dataSource: .custom
        )
        
        deviceProfileManager.saveProfile(profile)
        deviceProfiles.append(profile)
        
        return profile
    }
    
    func deleteProfile(_ profile: DeviceProfile) {
        deviceProfileManager.deleteProfile(profile)
        deviceProfiles.removeAll { $0.id == profile.id }
        
        if selectedProfile?.id == profile.id {
            selectedProfile = nil
        }
    }
    
    func refreshExternalData() async {
        isLoading = true
        
        // Clear existing external profiles
        deviceProfiles.removeAll { $0.dataSource == .oratory1990 || $0.dataSource == .crinacle }
        
        await loadExternalProfiles()
        
        isLoading = false
    }
    
    func getProfilesByType(_ type: DeviceProfile.DeviceType) -> [DeviceProfile] {
        return deviceProfiles.filter { $0.deviceType == type }
    }
    
    func getProfilesBySource(_ source: DeviceProfile.DataSource) -> [DeviceProfile] {
        return deviceProfiles.filter { $0.dataSource == source }
    }
}