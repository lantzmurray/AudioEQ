//
//  EQModeToggle.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

struct EQModeToggle: View {
    @EnvironmentObject var eqViewModel: EQViewModel
    
    var body: some View {
        HStack {
            Text("EQ Mode")
                .font(.headline)
            
            Spacer()
            
            Picker("EQ Mode", selection: $eqViewModel.mode) {
                ForEach(EQMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
        }
        .padding(.horizontal)
    }
}

struct EQModeToggle_Previews: PreviewProvider {
    static var previews: some View {
        EQModeToggle()
            .environmentObject(EQViewModel())
            .frame(width: 400, height: 50)
    }
}