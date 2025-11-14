//
//  ExternalDataService.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation

class ExternalDataService {
    private let session = URLSession.shared
    
    func fetchOratory1990Data() async throws -> [DeviceProfile] {
        // In a real implementation, this would fetch data from Oratory1990's GitHub repository
        // For now, we'll return mock data that simulates the structure
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        return [
            DeviceProfile(
                name: "Sennheiser HD 650",
                manufacturer: "Sennheiser",
                model: "HD 650",
                deviceType: .headphone,
                frequencyResponse: generateOratory1990Response(for: "HD650"),
                recommendedEQ: generateOratory1990EQ(for: "HD650"),
                dataSource: .oratory1990
            ),
            DeviceProfile(
                name: "Beyerdynamic DT 770 Pro",
                manufacturer: "Beyerdynamic",
                model: "DT 770 Pro",
                deviceType: .studioMonitor,
                frequencyResponse: generateOratory1990Response(for: "DT770"),
                recommendedEQ: generateOratory1990EQ(for: "DT770"),
                dataSource: .oratory1990
            ),
            DeviceProfile(
                name: "Audio-Technica ATH-M50x",
                manufacturer: "Audio-Technica",
                model: "ATH-M50x",
                deviceType: .studioMonitor,
                frequencyResponse: generateOratory1990Response(for: "M50x"),
                recommendedEQ: generateOratory1990EQ(for: "M50x"),
                dataSource: .oratory1990
            ),
            DeviceProfile(
                name: "Shure SE215",
                manufacturer: "Shure",
                model: "SE215",
                deviceType: .inEar,
                frequencyResponse: generateOratory1990Response(for: "SE215"),
                recommendedEQ: generateOratory1990EQ(for: "SE215"),
                dataSource: .oratory1990
            )
        ]
    }
    
    func fetchCrinacleData() async throws -> [DeviceProfile] {
        // In a real implementation, this would fetch data from Crinacle's database
        // For now, we'll return mock data
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        return [
            DeviceProfile(
                name: "Apple AirPods Pro",
                manufacturer: "Apple",
                model: "AirPods Pro",
                deviceType: .inEar,
                frequencyResponse: generateCrinacleResponse(for: "AirPodsPro"),
                recommendedEQ: generateCrinacleEQ(for: "AirPodsPro"),
                dataSource: .crinacle
            ),
            DeviceProfile(
                name: "Sony WH-1000XM4",
                manufacturer: "Sony",
                model: "WH-1000XM4",
                deviceType: .headphone,
                frequencyResponse: generateCrinacleResponse(for: "WH1000XM4"),
                recommendedEQ: generateCrinacleEQ(for: "WH1000XM4"),
                dataSource: .crinacle
            ),
            DeviceProfile(
                name: "Bose QuietComfort 35 II",
                manufacturer: "Bose",
                model: "QuietComfort 35 II",
                deviceType: .headphone,
                frequencyResponse: generateCrinacleResponse(for: "QC35II"),
                recommendedEQ: generateCrinacleEQ(for: "QC35II"),
                dataSource: .crinacle
            ),
            DeviceProfile(
                name: "Sennheiser Momentum True Wireless 3",
                manufacturer: "Sennheiser",
                model: "Momentum True Wireless 3",
                deviceType: .inEar,
                frequencyResponse: generateCrinacleResponse(for: "MTW3"),
                recommendedEQ: generateCrinacleEQ(for: "MTW3"),
                dataSource: .crinacle
            )
        ]
    }
    
    // MARK: - Mock Data Generation
    
    private func generateOratory1990Response(for model: String) -> [FrequencyPoint] {
        switch model {
        case "HD650":
            return [
                FrequencyPoint(frequency: 20, amplitude: -2.1),
                FrequencyPoint(frequency: 30, amplitude: -1.8),
                FrequencyPoint(frequency: 60, amplitude: -1.2),
                FrequencyPoint(frequency: 125, amplitude: -0.8),
                FrequencyPoint(frequency: 250, amplitude: -0.5),
                FrequencyPoint(frequency: 500, amplitude: 0.2),
                FrequencyPoint(frequency: 1000, amplitude: 0.8),
                FrequencyPoint(frequency: 2000, amplitude: 1.2),
                FrequencyPoint(frequency: 4000, amplitude: 2.1),
                FrequencyPoint(frequency: 8000, amplitude: 1.8),
                FrequencyPoint(frequency: 16000, amplitude: -1.5),
                FrequencyPoint(frequency: 20000, amplitude: -8.2)
            ]
        case "DT770":
            return [
                FrequencyPoint(frequency: 20, amplitude: -1.5),
                FrequencyPoint(frequency: 30, amplitude: -1.2),
                FrequencyPoint(frequency: 60, amplitude: -0.8),
                FrequencyPoint(frequency: 125, amplitude: -0.3),
                FrequencyPoint(frequency: 250, amplitude: 0.5),
                FrequencyPoint(frequency: 500, amplitude: 1.2),
                FrequencyPoint(frequency: 1000, amplitude: 1.8),
                FrequencyPoint(frequency: 2000, amplitude: 2.5),
                FrequencyPoint(frequency: 4000, amplitude: 3.2),
                FrequencyPoint(frequency: 8000, amplitude: 2.8),
                FrequencyPoint(frequency: 16000, amplitude: -0.8),
                FrequencyPoint(frequency: 20000, amplitude: -6.5)
            ]
        default:
            return generateDefaultFrequencyResponse()
        }
    }
    
    private func generateOratory1990EQ(for model: String) -> EQSettings {
        let preset = EQSettings(name: "\(model) Target", mode: .parametric)
        
        switch model {
        case "HD650":
            preset.parametricBands = [
                ParametricBand(frequency: 60, gain: 1.2, q: 0.8, filterType: .bell),
                ParametricBand(frequency: 250, gain: 0.5, q: 1.0, filterType: .bell),
                ParametricBand(frequency: 1000, gain: -0.8, q: 1.2, filterType: .bell),
                ParametricBand(frequency: 4000, gain: -2.1, q: 1.5, filterType: .bell),
                ParametricBand(frequency: 12000, gain: 3.5, q: 2.0, filterType: .highShelf)
            ]
        case "DT770":
            preset.parametricBands = [
                ParametricBand(frequency: 80, gain: 0.8, q: 0.7, filterType: .bell),
                ParametricBand(frequency: 300, gain: -1.2, q: 1.0, filterType: .bell),
                ParametricBand(frequency: 1000, gain: -1.8, q: 1.2, filterType: .bell),
                ParametricBand(frequency: 4000, gain: -3.2, q: 1.8, filterType: .bell),
                ParametricBand(frequency: 14000, gain: 2.5, q: 2.5, filterType: .highShelf)
            ]
        default:
            break
        }
        
        return preset
    }
    
    private func generateCrinacleResponse(for model: String) -> [FrequencyPoint] {
        switch model {
        case "AirPodsPro":
            return [
                FrequencyPoint(frequency: 20, amplitude: -5.2),
                FrequencyPoint(frequency: 30, amplitude: -4.8),
                FrequencyPoint(frequency: 60, amplitude: 2.1),
                FrequencyPoint(frequency: 125, amplitude: 3.5),
                FrequencyPoint(frequency: 250, amplitude: 2.8),
                FrequencyPoint(frequency: 500, amplitude: 1.2),
                FrequencyPoint(frequency: 1000, amplitude: 1.8),
                FrequencyPoint(frequency: 2000, amplitude: 3.2),
                FrequencyPoint(frequency: 4000, amplitude: 4.1),
                FrequencyPoint(frequency: 8000, amplitude: -2.1),
                FrequencyPoint(frequency: 16000, amplitude: -8.5),
                FrequencyPoint(frequency: 20000, amplitude: -12.8)
            ]
        case "WH1000XM4":
            return [
                FrequencyPoint(frequency: 20, amplitude: -3.8),
                FrequencyPoint(frequency: 30, amplitude: -3.2),
                FrequencyPoint(frequency: 60, amplitude: 1.5),
                FrequencyPoint(frequency: 125, amplitude: 2.8),
                FrequencyPoint(frequency: 250, amplitude: 2.1),
                FrequencyPoint(frequency: 500, amplitude: 0.8),
                FrequencyPoint(frequency: 1000, amplitude: 1.2),
                FrequencyPoint(frequency: 2000, amplitude: 2.5),
                FrequencyPoint(frequency: 4000, amplitude: 3.8),
                FrequencyPoint(frequency: 8000, amplitude: -1.2),
                FrequencyPoint(frequency: 16000, amplitude: -6.8),
                FrequencyPoint(frequency: 20000, amplitude: -10.5)
            ]
        default:
            return generateDefaultFrequencyResponse()
        }
    }
    
    private func generateCrinacleEQ(for model: String) -> EQSettings {
        let preset = EQSettings(name: "\(model) Target", mode: .parametric)
        
        switch model {
        case "AirPodsPro":
            preset.parametricBands = [
                ParametricBand(frequency: 50, gain: 4.5, q: 0.6, filterType: .lowShelf),
                ParametricBand(frequency: 200, gain: -2.8, q: 1.0, filterType: .bell),
                ParametricBand(frequency: 1000, gain: -1.8, q: 1.2, filterType: .bell),
                ParametricBand(frequency: 6000, gain: -3.5, q: 2.0, filterType: .bell),
                ParametricBand(frequency: 12000, gain: 8.5, q: 2.5, filterType: .highShelf)
            ]
        case "WH1000XM4":
            preset.parametricBands = [
                ParametricBand(frequency: 60, gain: 3.2, q: 0.7, filterType: .lowShelf),
                ParametricBand(frequency: 250, gain: -2.1, q: 1.0, filterType: .bell),
                ParametricBand(frequency: 1000, gain: -1.2, q: 1.2, filterType: .bell),
                ParametricBand(frequency: 5000, gain: -3.8, q: 1.8, filterType: .bell),
                ParametricBand(frequency: 14000, gain: 7.5, q: 2.2, filterType: .highShelf)
            ]
        default:
            break
        }
        
        return preset
    }
    
    private func generateDefaultFrequencyResponse() -> [FrequencyPoint] {
        let frequencies = [20, 30, 60, 125, 250, 500, 1000, 2000, 4000, 8000, 16000, 20000]
        return frequencies.map { FrequencyPoint(frequency: $0, amplitude: 0.0) }
    }
}