//
//  Task.swift
//  TaskTracker
//
//  Created by picnic on 8/4/26.
//

import Foundation
import SwiftData

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
