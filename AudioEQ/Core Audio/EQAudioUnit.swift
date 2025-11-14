//
//  EQAudioUnit.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation
import AVFoundation
import Accelerate

class EQAudioUnit: ObservableObject {
    private var audioUnit: AVAudioUnitEQ?
    private var audioEngine: AVAudioEngine?
    private var isInitialized = false
    
    @Published var isProcessing = false
    
    // Graphic EQ frequencies (10-band)
    private let graphicFrequencies: [Float] = [32, 64, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    
    // Audio format
    private let audioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
    
    init() {
        setupAudioUnit()
    }
    
    deinit {
        cleanup()
    }
    
    private func setupAudioUnit() {
        // Create EQ unit with 10 bands for graphic EQ
        audioUnit = AVAudioUnitEQ(numberOfBands: 10)
        
        guard let eqUnit = audioUnit else {
            print("Failed to create EQ audio unit")
            return
        }
        
        // Configure default EQ bands
        configureDefaultBands()
        
        // Setup audio engine
        audioEngine = AVAudioEngine()
        
        guard let engine = audioEngine else {
            print("Failed to create audio engine")
            return
        }
        
        // Attach and connect the EQ unit
        engine.attach(eqUnit)
        
        // Create a player node for testing
        let playerNode = AVAudioPlayerNode()
        engine.attach(playerNode)
        
        // Connect nodes: player -> EQ -> main mixer -> output
        engine.connect(playerNode, to: eqUnit, format: audioFormat)
        engine.connect(eqUnit, to: engine.mainMixerNode, format: audioFormat)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: audioFormat)
        
        isInitialized = true
    }
    
    private func configureDefaultBands() {
        guard let eqUnit = audioUnit else { return }
        
        for (index, frequency) in graphicFrequencies.enumerated() {
            if index < eqUnit.bands.count {
                let band = eqUnit.bands[index]
                band.frequency = frequency
                band.gain = 0.0
                band.bypass = false
                band.filterType = .parametric
                band.q = 1.0
            }
        }
    }
    
    func startProcessing() throws {
        guard isInitialized, let engine = audioEngine else {
            throw EQAudioUnitError.notInitialized
        }
        
        // Start the audio engine
        try engine.start()
        
        DispatchQueue.main.async {
            self.isProcessing = true
        }
    }
    
    func stopProcessing() {
        guard let engine = audioEngine else { return }
        
        engine.stop()
        
        DispatchQueue.main.async {
            self.isProcessing = false
        }
    }
    
    func applyGraphicEQSettings(_ bands: [GraphicBand]) {
        guard let eqUnit = audioUnit else { return }
        
        for (index, band) in bands.enumerated() {
            if index < eqUnit.bands.count {
                let eqBand = eqUnit.bands[index]
                eqBand.gain = Float(band.gain)
                eqBand.bypass = false
                eqBand.filterType = .parametric
                eqBand.q = 1.0
            }
        }
    }
    
    func applyParametricEQSettings(_ bands: [ParametricBand]) {
        guard let eqUnit = audioUnit else { return }
        
        for (index, band) in bands.enumerated() {
            if index < eqUnit.bands.count {
                let eqBand = eqUnit.bands[index]
                eqBand.frequency = Float(band.frequency)
                eqBand.gain = Float(band.gain)
                eqBand.q = Float(band.q)
                eqBand.bypass = !band.isEnabled
                
                // Convert filter type
                switch band.filterType {
                case .bell:
                    eqBand.filterType = .parametric
                case .lowShelf:
                    eqBand.filterType = .lowShelf
                case .highShelf:
                    eqBand.filterType = .highShelf
                case .lowPass:
                    eqBand.filterType = .lowPass
                case .highPass:
                    eqBand.filterType = .highPass
                }
            }
        }
    }
    
    func setBypass(_ bypass: Bool) {
        guard let eqUnit = audioUnit else { return }
        
        for band in eqUnit.bands {
            band.bypass = bypass
        }
    }
    
    func resetToFlat() {
        guard let eqUnit = audioUnit else { return }
        
        for band in eqUnit.bands {
            band.gain = 0.0
            band.bypass = false
        }
    }
    
    func getCurrentEQSettings() -> EQSettings {
        guard let eqUnit = audioUnit else {
            return EQSettings.flat
        }
        
        var graphicBands: [GraphicBand] = []
        var parametricBands: [ParametricBand] = []
        
        for (index, band) in eqUnit.bands.enumerated() {
            // Create graphic band
            let graphicBand = GraphicBand(
                frequency: Int(band.frequency),
                gain: Double(band.gain)
            )
            graphicBands.append(graphicBand)
            
            // Create parametric band
            let filterType: ParametricBand.FilterType
            switch band.filterType {
            case .parametric:
                filterType = .bell
            case .lowShelf:
                filterType = .lowShelf
            case .highShelf:
                filterType = .highShelf
            case .lowPass:
                filterType = .lowPass
            case .highPass:
                filterType = .highPass
            @unknown default:
                filterType = .bell
            }
            
            let parametricBand = ParametricBand(
                frequency: Double(band.frequency),
                gain: Double(band.gain),
                q: Double(band.q),
                filterType: filterType,
                isEnabled: !band.bypass
            )
            parametricBands.append(parametricBand)
        }
        
        return EQSettings(
            name: "Current",
            mode: .graphic // Default to graphic mode
        )
    }
    
    func getFrequencyResponse() -> [FrequencyPoint] {
        guard let eqUnit = audioUnit else {
            return []
        }
        
        var response: [FrequencyPoint] = []
        let frequencies = generateLogarithmicFrequencies(from: 20, to: 20000, count: 100)
        
        for frequency in frequencies {
            let gain = calculateFrequencyResponse(frequency, bands: eqUnit.bands)
            response.append(FrequencyPoint(frequency: frequency, amplitude: gain))
        }
        
        return response
    }
    
    private func calculateFrequencyResponse(_ frequency: Double, bands: [AVAudioUnitEQBandParameters]) -> Double {
        var totalGain: Double = 0.0
        
        for band in bands {
            if band.bypass { continue }
            
            let bandFreq = Double(band.frequency)
            let bandGain = Double(band.gain)
            let bandQ = Double(band.q)
            
            // Calculate filter response based on type
            let filterResponse: Double
            
            switch band.filterType {
            case .parametric:
                filterResponse = calculateBellFilter(frequency, centerFreq: bandFreq, gain: bandGain, q: bandQ)
            case .lowShelf:
                filterResponse = calculateLowShelfFilter(frequency, cornerFreq: bandFreq, gain: bandGain, q: bandQ)
            case .highShelf:
                filterResponse = calculateHighShelfFilter(frequency, cornerFreq: bandFreq, gain: bandGain, q: bandQ)
            case .lowPass:
                filterResponse = calculateLowPassFilter(frequency, cutoffFreq: bandFreq, q: bandQ)
            case .highPass:
                filterResponse = calculateHighPassFilter(frequency, cutoffFreq: bandFreq, q: bandQ)
            @unknown default:
                filterResponse = 0.0
            }
            
            totalGain += filterResponse
        }
        
        return totalGain
    }
    
    private func calculateBellFilter(_ frequency: Double, centerFreq: Double, gain: Double, q: Double) -> Double {
        let omega = 2.0 * .pi * frequency
        let omega0 = 2.0 * .pi * centerFreq
        let sinOmega0 = sin(omega0)
        let cosOmega0 = cos(omega0)
        let alpha = sinOmega0 / (2.0 * q)
        
        let b0 = 1.0 + alpha * gain
        let b1 = -2.0 * cosOmega0
        let b2 = 1.0 - alpha * gain
        let a0 = 1.0 + alpha
        let a1 = -2.0 * cosOmega0
        let a2 = 1.0 - alpha
        
        // Simplified frequency response calculation
        let omega2 = omega * omega
        let cosOmega = cos(omega)
        
        let numerator = b0 + b1 * cosOmega + b2 * omega2
        let denominator = a0 + a1 * cosOmega + a2 * omega2
        
        return numerator / denominator
    }
    
    private func calculateLowShelfFilter(_ frequency: Double, cornerFreq: Double, gain: Double, q: Double) -> Double {
        let omega = 2.0 * .pi * frequency
        let omega0 = 2.0 * .pi * cornerFreq
        let sinOmega0 = sin(omega0)
        let cosOmega0 = cos(omega0)
        let alpha = sinOmega0 / (2.0 * q)
        let a = sqrt(gain) - 1.0
        
        let b0 = gain * ((gain + 1.0) + (gain - 1.0) * cosOmega0 + 2.0 * sqrt(gain) * alpha)
        let b1 = -2.0 * gain * ((gain - 1.0) + (gain + 1.0) * cosOmega0)
        let b2 = gain * ((gain + 1.0) + (gain - 1.0) * cosOmega0 - 2.0 * sqrt(gain) * alpha)
        let a0 = (gain + 1.0) + (gain - 1.0) * cosOmega0 + 2.0 * sqrt(gain) * alpha
        let a1 = -2.0 * ((gain - 1.0) + (gain + 1.0) * cosOmega0)
        let a2 = (gain + 1.0) + (gain - 1.0) * cosOmega0 - 2.0 * sqrt(gain) * alpha
        
        let omega2 = omega * omega
        let cosOmega = cos(omega)
        
        let numerator = b0 + b1 * cosOmega + b2 * omega2
        let denominator = a0 + a1 * cosOmega + a2 * omega2
        
        return numerator / denominator
    }
    
    private func calculateHighShelfFilter(_ frequency: Double, cornerFreq: Double, gain: Double, q: Double) -> Double {
        // Similar to low shelf but with frequency inversion
        return calculateLowShelfFilter(20000.0 - frequency, cornerFreq: 20000.0 - cornerFreq, gain: gain, q: q)
    }
    
    private func calculateLowPassFilter(_ frequency: Double, cutoffFreq: Double, q: Double) -> Double {
        let omega = 2.0 * .pi * frequency
        let omega0 = 2.0 * .pi * cutoffFreq
        let sinOmega0 = sin(omega0)
        let cosOmega0 = cos(omega0)
        let alpha = sinOmega0 / (2.0 * q)
        
        let b1 = 1.0 - cosOmega0
        let b2 = 1.0 - cosOmega0 + alpha
        let a0 = 1.0 + alpha
        let a1 = -2.0 * cosOmega0
        let a2 = 1.0 - alpha
        
        let omega2 = omega * omega
        let cosOmega = cos(omega)
        
        let numerator = b2 + b1 * cosOmega
        let denominator = a0 + a1 * cosOmega + a2 * omega2
        
        return numerator / denominator
    }
    
    private func calculateHighPassFilter(_ frequency: Double, cutoffFreq: Double, q: Double) -> Double {
        // High pass is inverse of low pass
        return 1.0 - calculateLowPassFilter(frequency, cutoffFreq: cutoffFreq, q: q)
    }
    
    private func generateLogarithmicFrequencies(from startFreq: Double, to endFreq: Double, count: Int) -> [Double] {
        var frequencies: [Double] = []
        let logStart = log10(startFreq)
        let logEnd = log10(endFreq)
        let step = (logEnd - logStart) / Double(count - 1)
        
        for i in 0..<count {
            let logFreq = logStart + step * Double(i)
            frequencies.append(pow(10, logFreq))
        }
        
        return frequencies
    }
    
    private func cleanup() {
        stopProcessing()
        audioUnit = nil
        audioEngine = nil
        isInitialized = false
    }
}

enum EQAudioUnitError: Error {
    case notInitialized
    case audioUnitCreationFailed
    case engineStartFailed
    
    var localizedDescription: String {
        switch self {
        case .notInitialized:
            return "EQ Audio Unit is not initialized"
        case .audioUnitCreationFailed:
            return "Failed to create EQ Audio Unit"
        case .engineStartFailed:
            return "Failed to start audio engine"
        }
    }
}