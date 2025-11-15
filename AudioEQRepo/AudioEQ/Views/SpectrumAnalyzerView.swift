//
//  SpectrumAnalyzerView.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI
import Accelerate

struct SpectrumAnalyzerView: View {
    @StateObject private var spectrumAnalyzer = SpectrumAnalyzer()
    @State private var isAnalyzing = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text("Spectrum Analyzer")
                    .font(.headline)
                
                Spacer()
                
                Button(action: toggleAnalysis) {
                    Image(systemName: isAnalyzing ? "stop.circle.fill" : "play.circle.fill")
                        .foregroundColor(isAnalyzing ? .red : .green)
                }
                .buttonStyle(.borderless)
            }
            
            // Spectrum display
            Canvas { context, size in
                drawSpectrum(context: context, size: size)
            }
            .frame(height: 120)
            .background(Color.black)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            // Frequency labels
            HStack {
                ForEach(spectrumFrequencyLabels, id: \.self) { label in
                    Text(label)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .onAppear {
            spectrumAnalyzer.start()
        }
        .onDisappear {
            spectrumAnalyzer.stop()
        }
    }
    
    private func toggleAnalysis() {
        if isAnalyzing {
            spectrumAnalyzer.stop()
        } else {
            spectrumAnalyzer.start()
        }
        isAnalyzing.toggle()
    }
    
    private func drawSpectrum(context: GraphicsContext, size: CGSize) {
        let spectrumData = spectrumAnalyzer.spectrumData
        
        guard !spectrumData.isEmpty else { return }
        
        let barWidth = size.width / CGFloat(spectrumData.count)
        let maxHeight = size.height
        
        // Draw bars
        for (index, amplitude) in spectrumData.enumerated() {
            let barHeight = CGFloat(amplitude) * maxHeight
            let barRect = CGRect(
                x: CGFloat(index) * barWidth,
                y: maxHeight - barHeight,
                width: barWidth - 1, // Small gap between bars
                height: barHeight
            )
            
            // Color based on frequency
            let hue = CGFloat(index) / CGFloat(spectrumData.count) * 0.8 // 0 to 0.8 (red to purple)
            let color = Color(hue: hue, saturation: 0.8, brightness: 0.9)
            
            context.fill(Path(barRect), with: .color(color))
        }
        
        // Draw grid lines
        drawGridLines(context: context, size: size)
    }
    
    private func drawGridLines(context: GraphicsContext, size: CGSize) {
        let gridColor = Color.gray.opacity(0.3)
        
        // Horizontal grid lines
        for i in 0...4 {
            let y = size.height * CGFloat(i) / 4.0
            let startPoint = CGPoint(x: 0, y: y)
            let endPoint = CGPoint(x: size.width, y: y)
            
            var path = Path()
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            context.stroke(path, with: .color(gridColor), lineWidth: 0.5)
        }
    }
    
    private var spectrumFrequencyLabels: [String] {
        ["20Hz", "100Hz", "1kHz", "10kHz", "20kHz"]
    }
}

class SpectrumAnalyzer: ObservableObject {
    @Published var spectrumData: [Float] = []

    private var audioEngine: AudioEngineManager?
    private var timer: Timer?
    private let fftSize = 1024
    private var isRunning = false

    init() {
        spectrumData = Array(repeating: 0.0, count: 64)
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        // 30Hz refresh rate for smooth animation
        timer = Timer.scheduledTimer(
            withTimeInterval: 1.0 / 30.0,
            repeats: true
        ) { [weak self] _ in
            self?.updateSpectrum()
        }

        audioEngine?.startAnalysis()
    }

    func stop() {
        guard isRunning else { return }
        isRunning = false

        timer?.invalidate()
        timer = nil
        audioEngine?.stopAnalysis()
    }

    private func updateSpectrum() {
        // Replace with real FFT later
        generateMockSpectrumData()
    }

    private func generateMockSpectrumData() {
        let time = Date().timeIntervalSince1970
        var newData: [Float] = []

        for i in 0..<64 {
            let frequency = Double(i) / 64.0
            let amplitude =
                sin(time * 2.0 + frequency * 10.0) * 0.3 +
                sin(time * 3.7 + frequency * 15.0) * 0.2 +
                sin(time * 1.3 + frequency * 5.0) * 0.5

            let normalized = (amplitude + 1) * 0.5
            let shaped = normalized * exp(-frequency * 2.0)
            newData.append(Float(shaped))
        }

        DispatchQueue.main.async {
            self.spectrumData = newData
        }
    }

    deinit {
        stop()
    }
}


struct SpectrumAnalyzerView_Previews: PreviewProvider {
    static var previews: some View {
        SpectrumAnalyzerView()
            .frame(width: 350, height: 200)
    }
}
