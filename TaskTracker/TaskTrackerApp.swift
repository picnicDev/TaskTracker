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
    var modelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: TaskSchemaV3.self)
        let config = ModelConfiguration(schema: schema)
        
        do {
            let modelContainer = try ModelContainer(
                for: schema,
                migrationPlan: TaskMigrationPlan.self,
                configurations: [config]
            )
            print("모델 컨테이서 생성 성공! 마이그레이션 통과!")
            
            return modelContainer
        } catch {
            print("마이그레이션 실패: \(error)")
            fatalError("마이그레이션 실패: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}

