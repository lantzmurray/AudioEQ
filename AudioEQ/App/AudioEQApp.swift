//
//  AudioEQApp.swift
//  AudioEQ
//
//  Created by Developer on 11/14/25.
//

import SwiftUI

@main
struct AudioEQApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
    }
}