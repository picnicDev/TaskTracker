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
            Text("\(task.title)")
            Spacer()
            Image(systemName: task.isDone ? "checkmark.circle" : "x.circle")
                .foregroundStyle(task.isDone ? .green : .red)
        }
    }
}

