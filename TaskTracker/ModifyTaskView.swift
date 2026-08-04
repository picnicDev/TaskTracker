//
//  ModifyTaskView.swift
//  TaskTracker
//
//  Created by picnic on 8/4/26.
//

import SwiftUI
import SwiftData

struct ModifyTaskView: View {
    var task: Task? = nil
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var isDone: Bool = false
    
    @State private var originalTitle: String = ""
    @State private var originalIsDone: Bool = false
    
    private var canSave: Bool {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasTitle = !trimmed.isEmpty
        if let _ = task {
            // editing: enable only if there is a change and title is present
            let changed = (title != originalTitle) || (isDone != originalIsDone)
            return hasTitle && changed
        } else {
            // creating: enable only if title is present
            return hasTitle
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Section {
                    TextField("Write the title of Task", text: $title)
                } header: {
                    HStack {
                        Text("Title")
                            .font(.headline)
                        Spacer()
                    }
                }
                
                Spacer()
                    .frame(height: 16)
                
                Section {
                    Toggle("isDone", isOn: $isDone)
                        .font(.headline)
                }
                
                Spacer()
            }
            .onAppear {
                if let task {
                    title = task.title
                    isDone = task.isDone
                    originalTitle = task.title
                    originalIsDone = task.isDone
                } else {
                    originalTitle = ""
                    originalIsDone = false
                }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // save
                        if let task {
                            // update existing
                            task.title = title
                            task.isDone = isDone
                        } else {
                            // create new
                            let newTask = Task(title: title, isDone: isDone)
                            context.insert(newTask)
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    ModifyTaskView(task: nil)
}
