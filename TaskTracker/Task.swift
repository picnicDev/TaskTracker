//
//  Task.swift
//  TaskTracker
//
//  Created by picnic on 8/4/26.
//

import Foundation
import SwiftData

enum TaskSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Task.self]
    }
    
    @Model
    class Task {
        var title: String
        var isDone: Bool
        var createdAt: Date


        init(title: String,
             isDone: Bool = false,
             createdAt: Date = .now
        ) {
            self.title = title
            self.isDone = isDone
            self.createdAt = createdAt
        }
    }
}

enum TaskSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Task.self]
    }
    

    @Model
    class Task {
        var title: String
        var isDone: Bool
        var createdAt: Date
        var priority: Int = 0  // 추가된 필드
        var dueDate: Date?
        
        init(title: String, isDone: Bool = false, createdAt: Date = .now, priority: Int = 0, dueDate: Date? = nil) {
            self.title = title
            self.isDone = isDone
            self.createdAt = createdAt
            self.priority = priority
            self.dueDate = dueDate
        }
    }
}
