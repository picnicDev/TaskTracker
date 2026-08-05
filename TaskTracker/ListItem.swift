//
//  ListItem.swift
//  TaskTracker
//
//  Created by picnic on 8/4/26.
//

import SwiftUI

struct ListItem: View {
    var task: Task
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(task.title)")
                HStack {
                    Text("status: \(task.status.rawValue)")
                    Text("/ priority: \(task.priority)")
                    Text("/ dueDate: \(task.dueDate?.description ?? "none")")
                }
                .font(.caption)
            }
            Spacer()
            Image(systemName: task.isDone ? "checkmark.circle" : "x.circle")
                .foregroundStyle(task.isDone ? .green : .red)
        }
    }
}

