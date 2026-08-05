//
//  MigrationPlan.swift
//  TaskTracker
//
//  Created by picnic on 8/5/26.
//

import Foundation
import SwiftData

typealias Task = TaskSchemaV4.Task
typealias TaskStatus = TaskSchemaV4.TaskStatus

enum TaskMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [TaskSchemaV1.self, TaskSchemaV2.self, TaskSchemaV3.self, TaskSchemaV4.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2, migrateV2toV3, migrateV3toV4]
    }
    
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: TaskSchemaV1.self,
        toVersion: TaskSchemaV2.self
    )
    
    // V2 -> V3: custom (title unique 추가 -> 중복 정리 필요 + status 값 채우기)
    static let migrateV2toV3 = MigrationStage.custom(
        fromVersion: TaskSchemaV2.self,
        toVersion: TaskSchemaV3.self) { context in
            print("🔍 [V2→V3 willMigrate] 시작")
            
            // 1) unique 제약을 걸기 전에 중복 title 정리
            // 아직 V2 컨텍스트라서 title이 unique가 아님 -> 자유롭게 조회 가능
            let allTasks = try context.fetch(FetchDescriptor<TaskSchemaV2.Task>())
            print(" V2 데이터 총 \(allTasks.count)개")
            
            var seenTitles: Set<String> = []
            var duplicatesToDelete: [TaskSchemaV2.Task] = []
            
            let sorted = allTasks.sorted { $0.createdAt < $1.createdAt }
            for task in sorted {
                if seenTitles.contains(task.title) {
                    print("중복 발견: \(task.title), 생성일: \(task.createdAt) -> 삭제 예정")
                    duplicatesToDelete.append(task)
                } else {
                    seenTitles.insert(task.title)
                }
            }
            
            for dup in duplicatesToDelete {
                context.delete(dup)
            }
            
            if !duplicatesToDelete.isEmpty {
                try context.save()
                print("중복 \(duplicatesToDelete.count)개 삭제 완료")
            } else {
                print("중복 title 없음, 삭제 불필요")
            }
            
        } didMigrate: { context in
            print("✅ [V2→V3 didMigrate] 시작")
            
            // 2) isDone -> status 값 채우기
            //    같은 V3 컨텍스트 안에 isDone과 status가 동시에 존재하므로
            //    별도 매핑 없이 바로 값을 옮길 수 있음 (방법 B의 핵심 장점)
            let v3Tasks = try context.fetch(FetchDescriptor<TaskSchemaV3.Task>())
            print("   V3 데이터 \(v3Tasks.count)개")
            
            for task in v3Tasks {
                task.status = task.isDone ? .done : .todo
                print("   - \(task.title): isDone=\(task.isDone) → status=\(task.status)")
            }
            
            try context.save()
            print("✅ [V2→V3] status 채우기 완료")
        }
    
    static let migrateV3toV4 = MigrationStage.lightweight(
        fromVersion: TaskSchemaV3.self,
        toVersion: TaskSchemaV4.self
    )
    
}
