//
//  ContentView.swift
//  TaskTracker
//
//  Created by picnic on 8/4/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Task.createdAt) private var tasks: [Task]
    
    var body: some View {
        NavigationStack {
            List(tasks, id: \.self) { task in
                VStack {
                    Text("\(task.title)")
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // open createTask view
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}

private let previewContainer: ModelContainer = {
    let schema = Schema(Task.self)
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: schema, configurations: configuration)
    
    let context = modelContainer.mainContext
    context.insert(Task(title: "Task 1"))
    context.insert(Task(title: "Task 2"))
    context.insert(Task(title: "Task 3"))
    
    return modelContainer
}()
