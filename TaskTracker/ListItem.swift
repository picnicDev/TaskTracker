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
        var statusImageName: String {
            switch task.status {
            case .done: return "checkmark.circle"
            case .inProgress: return "arrow.clockwise.circle"
            case .todo: return "circle"
            }
        }
        
        var statusColor: Color {
            switch task.status {
            case .done: return .green
            case .inProgress: return .orange
            case .todo: return .blue
            }
        }
        
        HStack {
            VStack(alignment: .leading) {
                Text("\(task.title)")
                HStack {
                    Text("/ priority: \(task.priority)")
                    Text("/ dueDate: \(task.dueDate?.description ?? "none")")
                }
                .font(.caption)
            }
            Spacer()
            Image(systemName: statusImageName)
                .foregroundStyle(statusColor)
        }
    }
}

