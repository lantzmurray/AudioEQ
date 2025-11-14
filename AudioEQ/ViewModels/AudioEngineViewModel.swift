//
//  AudioEngineViewModel.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import Foundation
import Combine
import CoreAudio

class AudioEngineViewModel: ObservableObject {
    @Published var currentDevice: AudioDevice?
    @Published var availableDevices: [AudioDevice] = []
    @Published var isProcessing = false
    @Published var isInitialized = false
    
    private var audioEngineManager: AudioEngineManager?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Initialize with default device
        loadAvailableDevices()
    }
    
    func initializeAudioEngine() {
        audioEngineManager = AudioEngineManager()
        
        audioEngineManager?.$isProcessing
            .receive(on: DispatchQueue.main)
            .assign(to: \.isProcessing, on: self)
            .store(in: &cancellables)
        
        audioEngineManager?.initialize()
        isInitialized = true
        
        // Set default device if available
        if let defaultDevice = availableDevices.first {
            switchToDevice(defaultDevice)
        }
    }
    
    func loadAvailableDevices() {
        // Use the device manager to get real devices
        availableDevices = audioEngineManager?.getAvailableDevices() ?? []
    }
    
    func switchToDevice(_ device: AudioDevice) {
        currentDevice = device
        audioEngineManager?.switchToDevice(device)
    }
    
    func toggleProcessing() {
        if isProcessing {
            audioEngineManager?.stopProcessing()
        } else {
            audioEngineManager?.startProcessing()
        }
    }
    
    deinit {
        audioEngineManager?.cleanup()
    }
}