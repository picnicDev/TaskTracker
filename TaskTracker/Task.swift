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

enum TaskSchemaV3: VersionedSchema {
    static var versionIdentifier = Schema.Version(3, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Task.self]
    }
    
    enum TaskStatus: String, Codable, CaseIterable {
        case todo
        case inProgress
        case done
    }
    
    @Model
    class Task {
        @Attribute(.unique) var title: String
        var isDone: Bool // ⚠️ 아직 안 지움 (V4에서 제거 예정)
        var status: TaskStatus = TaskStatus.todo   // 새로 추가, 기본값 필요
        var createdAt: Date
        var priority: Int = 0
        var dueDate: Date?
        
        init(title: String, isDone: Bool = false, status: TaskStatus = .todo, createdAt: Date = .now, priority: Int = 0, dueDate: Date? = nil) {
            self.title = title
            self.isDone = isDone
            self.status = status
            self.createdAt = createdAt
            self.priority = priority
            self.dueDate = dueDate
        }
    }
}

enum TaskSchemaV4: VersionedSchema {
    static var versionIdentifier = Schema.Version(4, 0, 0)
    static var models: [any PersistentModel.Type] { [Task.self] }

    enum TaskStatus: String, Codable {
        case todo
        case inProgress
        case done
    }

    @Model
    class Task {
        @Attribute(.unique) var title: String
        var status: TaskStatus
        var createdAt: Date
        var priority: Int = 0
        var dueDate: Date?
        // isDone 완전히 제거됨

        init(
            title: String,
            status: TaskStatus,
            createdAt: Date,
            priority: Int = 0,
            dueDate: Date? = nil
        ) {
            self.title = title
            self.status = status
            self.createdAt = createdAt
            self.priority = priority
            self.dueDate = dueDate
        }
    }
}
