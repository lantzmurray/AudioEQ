//
//  AudioEngineManager.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation
import AVFoundation
import Combine

class AudioEngineManager: ObservableObject {
    // MARK: - Published State
    @Published var isProcessing = false
    @Published var currentDevice: AudioDevice?

    // MARK: - Audio Components
    private var audioEngine: AVAudioEngine?
    private var eqAudioUnit: EQAudioUnit?
    private var deviceManager: AudioDeviceManager?

    private var playerNode: AVAudioPlayerNode?
    private var inputNode: AVAudioInputNode?
    private var mixerNode: AVAudioMixerNode?

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        deviceManager = AudioDeviceManager.shared

        // Subscribe to default output device from AudioDeviceManager
        deviceManager?.$defaultOutputDevice
            .sink { [weak self] device in
                guard let device = device else { return }
                self?.currentDevice = device
                self?.switchToDevice(device)
            }
            .store(in: &cancellables)
    }

    // MARK: - Public API

    /// Call once from the app (e.g. onAppear) to set everything up
    func initialize() {
        guard audioEngine == nil else { return }   // avoid reinitializing
        setupAudioEngine()
        setupEQ()
        deviceManager?.refreshDevices()
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
        guard let eq = eqAudioUnit else { return }

        switch settings.mode {
        case .graphic:
            eq.applyGraphic(settings.graphicBands)
        case .parametric:
            eq.applyParametric(settings.parametricBands)
        }
    }

    func startAnalysis() {
        // Hook spectrum analyzer here later
        print("Starting audio analysis")
    }

    func stopAnalysis() {
        print("Stopping audio analysis")
    }

    func getAvailableDevices() -> [AudioDevice] {
        return deviceManager?.devices ?? []
    }

    func getCurrentEQSettings() -> EQSettings {
        return eqAudioUnit?.currentSettings() ?? EQSettings.flat
    }

    func getFrequencyResponse() -> [FrequencyPoint] {
        // Stub for now; can be wired to EQAudioUnit later
        return []
    }

    func cleanup() {
        stopProcessing()
        audioEngine?.stop()
        audioEngine = nil
        eqAudioUnit = nil
        deviceManager = nil
        playerNode = nil
        inputNode = nil
        mixerNode = nil
        cancellables.removeAll()
    }

    // MARK: - Device Handling

    func switchToDevice(_ device: AudioDevice) {
        currentDevice = device
        // Real CoreAudio device routing would be implemented here
        print("Switching to device: \(device.name)")
    }

    // MARK: - Private Setup

    private func setupAudioEngine() {
        let engine = AVAudioEngine()
        audioEngine = engine

        // Basic node graph: player -> mixer -> mainMixer -> output
        let player = AVAudioPlayerNode()
        let mixer = AVAudioMixerNode()

        playerNode = player
        mixerNode = mixer
        inputNode = engine.inputNode

        engine.attach(player)
        engine.attach(mixer)

        engine.connect(player, to: mixer, format: nil)
        engine.connect(mixer, to: engine.mainMixerNode, format: nil)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)
    }

    private func setupEQ() {
        guard let engine = audioEngine,
              let mixer = mixerNode else { return }

        // Create EQAudioUnit bound to this engine
        let eqUnit = EQAudioUnit(engine: engine)
        eqAudioUnit = eqUnit

        // Insert EQ after mixer
        eqUnit.insert(after: mixer)
    }
}
