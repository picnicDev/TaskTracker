//
//  TaskTrackerApp.swift
//  TaskTracker
//
//  Created by picnic on 8/4/26.
//

import SwiftUI
import SwiftData

@main
struct TaskTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Task.self)
    }
}
