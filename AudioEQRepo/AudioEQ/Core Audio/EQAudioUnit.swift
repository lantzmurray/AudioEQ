//
//  EQAudioUnit.swift
//  AudioEQ
//

import Foundation
import AVFoundation

/// Stand-alone EQ engine that plugs into AudioEngineManager
final class EQAudioUnit: ObservableObject {
    @Published var isProcessing = false

    private let eq: AVAudioUnitEQ
    private weak var engine: AVAudioEngine?

    /// 10-band graphic EQ standard ISO frequencies
    private let frequencies: [Float] = [32, 64, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]

    init(engine: AVAudioEngine) {
        self.engine = engine
        self.eq = AVAudioUnitEQ(numberOfBands: 10)
        configureBands()
        attachToEngine()
    }

    deinit {
        detachFromEngine()
    }

    // MARK: - Setup

    private func configureBands() {
        for (i, f) in frequencies.enumerated() {
            let band = eq.bands[i]
            band.frequency = f
            band.bandwidth = 1.0        // replaced `.q` (macOS correct API)
            band.gain = 0.0
            band.bypass = false
            band.filterType = .parametric
        }
    }
    
   

    private func attachToEngine() {
        guard let engine = engine else { return }
        engine.attach(eq)
    }

    func insert(after node: AVAudioNode) {
        guard let engine = engine else { return }
        engine.disconnectNodeOutput(node)
        engine.connect(node, to: eq, format: nil)
        engine.connect(eq, to: engine.mainMixerNode, format: nil)
    }

    private func detachFromEngine() {
        guard let engine = engine else { return }
        engine.detach(eq)
    }

    // MARK: - Controls

    func start() {
        isProcessing = true
    }

    func stop() {
        isProcessing = false
    }

    func applyGraphic(_ bands: [GraphicBand]) {
        for (i, band) in bands.enumerated() where i < eq.bands.count {
            eq.bands[i].gain = Float(band.gain)
        }
    }

    func applyParametric(_ bands: [ParametricBand]) {
        for (i, band) in bands.enumerated() where i < eq.bands.count {
            let b = eq.bands[i]
            b.frequency = Float(band.frequency)
            b.gain = Float(band.gain)
            b.bandwidth = Float(band.q)         // replaced `.q`
            b.bypass = !band.isEnabled

            switch band.filterType {
            case .bell:       b.filterType = .parametric
            case .lowShelf:   b.filterType = .lowShelf
            case .highShelf:  b.filterType = .highShelf
            case .lowPass:    b.filterType = .lowPass
            case .highPass:   b.filterType = .highPass
            }
        }
    }

    func reset() {
        for band in eq.bands {
            band.gain = 0.0
            band.bypass = false
        }
    }

    func currentSettings() -> EQSettings {
        var g: [GraphicBand] = []
        var p: [ParametricBand] = []

        for band in eq.bands {
            g.append(GraphicBand(
                frequency: Double(band.frequency),
                gain: Double(band.gain)
            ))

            let filter: ParametricBand.FilterType = {
                switch band.filterType {
                case .parametric: return .bell
                case .lowShelf: return .lowShelf
                case .highShelf: return .highShelf
                case .lowPass:  return .lowPass
                case .highPass: return .highPass
                default: return .bell
                }
            }()

            p.append(ParametricBand(
                frequency: Double(band.frequency),
                gain: Double(band.gain),
                q: Double(band.bandwidth),   // replaced `.q`
                filterType: filter,
                isEnabled: !band.bypass
            ))
        }

        return EQSettings(name: "Current", mode: .graphic, graphicBands: g, parametricBands: p)
    }
}


