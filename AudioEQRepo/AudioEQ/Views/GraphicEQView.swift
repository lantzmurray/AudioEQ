import SwiftUI

struct GraphicEQView: View {
    @Binding var bands: [GraphicBand]   // each band has frequency + gain

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ForEach(bands.indices, id: \.self) { index in
                VStack {
                    Text("\(Int(bands[index].frequency)) Hz")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Slider(
                        value: $bands[index].gain,
                        in: -12...12,
                        step: 1
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(height: 120)
                }
            }
        }
        .padding()
    }
}

struct GraphicEQView_Previews: PreviewProvider {
    @State static var previewBands = GraphicBand.default10Band
    
    static var previews: some View {
        GraphicEQView(bands: $previewBands)
            .frame(width: 800, height: 200)
    }
}


