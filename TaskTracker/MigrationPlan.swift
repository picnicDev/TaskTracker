//
//  MigrationPlan.swift
//  TaskTracker
//
//  Created by picnic on 8/5/26.
//

import Foundation
import SwiftData

enum TaskMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [TaskSchemaV1.self, TaskSchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: TaskSchemaV1.self,
        toVersion: TaskSchemaV2.self
    )
}
