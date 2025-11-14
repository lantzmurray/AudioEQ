//
//  AudioEngineManager.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation
import AVFoundation
import CoreAudio
import Combine

class AudioEngineManager: ObservableObject {
    @Published var isProcessing = false
    @Published var currentDevice: AudioDevice?
    
    private var audioEngine: AVAudioEngine?
    private var eqAudioUnit: EQAudioUnit?
    private var deviceManager: AudioDeviceManager?
    private var playerNode: AVAudioPlayerNode?
    private var inputNode: AVAudioInputNode?
    private var mixerNode: AVAudioMixerNode?
    
    private let session = AVAudioSession.sharedInstance()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupAudioSession()
        deviceManager = AudioDeviceManager()
        
        // Subscribe to device changes
        deviceManager?.$currentDevice
            .sink { [weak self] device in
                self?.currentDevice = device
                self?.switchToDevice(device)
            }
            .store(in: &cancellables)
    }
    
    func initialize() {
        setupAudioEngine()
        setupEQNode()
        deviceManager?.refreshDeviceList()
    }
    
    private func setupAudioSession() {
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        
        guard let audioEngine = audioEngine else { return }
        
        // Create nodes
        playerNode = AVAudioPlayerNode()
        inputNode = audioEngine.inputNode
        mixerNode = AVAudioMixerNode()
        
        // Attach nodes
        audioEngine.attach(playerNode!)
        audioEngine.attach(mixerNode!)
        
        // Connect nodes
        audioEngine.connect(playerNode!, to: mixerNode!, format: nil)
        audioEngine.connect(mixerNode!, to: audioEngine.mainMixerNode, format: nil)
        audioEngine.connect(audioEngine.mainMixerNode, to: audioEngine.outputNode, format: nil)
    }
    
    private func setupEQNode() {
        guard let audioEngine = audioEngine else { return }
        
        // Create EQ unit with 10 bands for graphic EQ
        eqNode = AVAudioUnitEQ(numberOfBands: 10)
        
        guard let eqNode = eqNode else { return }
        
        audioEngine.attach(eqNode)
        
        // Configure EQ bands
        let frequencies = [32, 64, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
        
        for (index, frequency) in frequencies.enumerated() {
            let band = eqNode.bands[index]
            band.frequency = Float(frequency)
            band.gain = 0.0
            band.bypass = false
            band.filterType = .parametric
            band.q = 1.0
        }
        
        // Reconnect nodes with EQ in the chain
        audioEngine.disconnectNodeInput(mixerNode!)
        audioEngine.connect(mixerNode!, to: eqNode, format: nil)
        audioEngine.connect(eqNode, to: audioEngine.mainMixerNode, format: nil)
    }
    
    func switchToDevice(_ device: AudioDevice) {
        currentDevice = device
        
        // In a real implementation, this would switch the audio output device
        // For now, we'll just update the current device property
        print("Switching to device: \(device.name)")
    }
    
    func startProcessing() {
        guard let audioEngine = audioEngine else { return }
        
        do {
            try audioEngine.start()
            isProcessing = true
            print("Audio engine started")
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    func stopProcessing() {
        guard let audioEngine = audioEngine else { return }
        
        audioEngine.stop()
        isProcessing = false
        print("Audio engine stopped")
    }
    
    func applyEQSettings(_ settings: EQSettings) {
        // Apply to our custom EQ unit
        eqAudioUnit?.applyEQSettings(settings)
        
        // Also apply to the built-in EQ unit as fallback
        guard let eqNode = eqNode else { return }
        
        switch settings.mode {
        case .graphic:
            applyGraphicEQ(settings.graphicBands, to: eqNode)
        case .parametric:
            applyParametricEQ(settings.parametricBands, to: eqNode)
        }
    }
    
    private func applyGraphicEQ(_ bands: [GraphicBand], to eqNode: AVAudioUnitEQ) {
        for (index, band) in bands.enumerated() {
            if index < eqNode.bands.count {
                let eqBand = eqNode.bands[index]
                eqBand.gain = Float(band.gain)
                eqBand.bypass = false
            }
        }
    }
    
    private func applyParametricEQ(_ bands: [ParametricBand], to eqNode: AVAudioUnitEQ) {
        for (index, band) in bands.enumerated() {
            if index < eqNode.bands.count {
                let eqBand = eqNode.bands[index]
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
    
    func startAnalysis() {
        // Start real-time audio analysis for spectrum analyzer
        // This would involve setting up audio analysis callbacks
        print("Starting audio analysis")
    }
    
    func stopAnalysis() {
        // Stop audio analysis
        print("Stopping audio analysis")
    }
    
    func getAvailableDevices() -> [AudioDevice] {
        return deviceManager?.availableDevices ?? []
    }
    
    func getCurrentEQSettings() -> EQSettings {
        return eqAudioUnit?.getCurrentEQSettings() ?? EQSettings.flat
    }
    
    func getFrequencyResponse() -> [FrequencyPoint] {
        return eqAudioUnit?.getFrequencyResponse() ?? []
    }
    
    func cleanup() {
        stopProcessing()
        audioEngine = nil
        eqAudioUnit = nil
        deviceManager = nil
        playerNode = nil
        inputNode = nil
        mixerNode = nil
        cancellables.removeAll()
    }
}