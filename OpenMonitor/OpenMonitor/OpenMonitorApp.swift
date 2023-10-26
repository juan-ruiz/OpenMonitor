//
//  OpenMonitorApp.swift
//  OpenMonitor
//
//  Created by Juan Ruiz on 19/10/23.
//

import SwiftUI
import SwiftData

@main
struct OpenMonitorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SelectInputView()
        }
        .modelContainer(sharedModelContainer)
    }
}
