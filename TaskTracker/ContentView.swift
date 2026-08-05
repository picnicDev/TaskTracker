//
//  ContentView.swift
//  TaskTracker
//
//  Created by picnic on 8/4/26.
//

import SwiftUI
import SwiftData

typealias Task = TaskSchemaV2.Task

struct ContentView: View {
    @Query(sort: \Task.createdAt, order: .forward) private var tasks: [Task]
    @Environment(\.modelContext) private var context
    
    @State private var isPresented: Bool = false
    @State private var selectedTask: Task? = nil
    
    var body: some View {
        NavigationStack {
            List(tasks, id: \.self) { task in
                Button {
                    selectedTask = task
                } label: {
                    ListItem(task: task)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedTask) { task in
                ModifyTaskView(task: task)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $isPresented) {
                ModifyTaskView(task: nil)
                    .presentationDragIndicator(.visible)
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
