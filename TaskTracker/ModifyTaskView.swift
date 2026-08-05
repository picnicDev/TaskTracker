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
    @State private var priority: Int = 0
    @State private var setDueDate: Bool = false
    @State private var dueDate: Date = .now
    @State private var status: TaskStatus = .todo
    
    @State private var originalTitle: String = ""
    @State private var originalPriority: Int = 0
    @State private var originalDueDate: Date? = nil
    @State private var originalStatus: TaskStatus = .todo
    
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
                    HStack {
                        Text("Status")
                            .font(.headline)
                        Spacer()
                        Picker("Status", selection: $status) {
                            ForEach(TaskStatus.allCases, id: \.self) { status in
                                Text(status.rawValue)
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 16)
                
                Section {
                    HStack {
                        Text("Priority")
                            .font(.headline)
                        Spacer()
                        Picker("Priority", selection: $priority) {
                            ForEach(Range(0...5), id: \.self) { priority in
                                Text("\(priority)").tag(priority)
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 16)
                
                Section {
                    Toggle("DueDate", isOn: $setDueDate)
                        .font(.headline)
                    
                    if setDueDate {
                        DatePicker("", selection: $dueDate, displayedComponents: [.date])
                            .font(.headline)
                    }
                }
  
                Spacer()
            }
            .onAppear {
                if let task {
                    title = task.title
                    priority = task.priority
                    status = task.status
                    originalTitle = task.title
                    originalPriority = task.priority
                    originalStatus = task.status

                    if let originalDueDate = task.dueDate {
                        setDueDate = true
                        self.originalDueDate = originalDueDate
                        dueDate = originalDueDate
                    } else {
                        setDueDate = false
                        self.originalDueDate = nil
                        // dueDate는 DatePicker 기본값으로 유지 (비교에는 사용되지 않음)
                    }
                } else {
                    originalTitle = ""
                    originalPriority = 0
                    originalDueDate = nil
                    originalStatus = .todo
                    setDueDate = false
                }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // save
                        if let task {
                            task.title = title
                            task.priority = priority
                            task.status = status
                            task.dueDate = setDueDate ? dueDate : nil
                        } else {
                            let newTask = Task(
                                title: title,
                                status: status,
                                priority: priority,
                                dueDate: setDueDate ? dueDate : nil
                            )
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
    
    private var canSave: Bool {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasTitle = !trimmed.isEmpty
        if let _ = task {
            // editing: enable only if there is a change and title is present
            let originalHasDueDate = (originalDueDate != nil)
            let dueDateChanged: Bool = {
                switch (setDueDate, originalHasDueDate) {
                case (false, false):
                    // 둘 다 없음 -> 변경 없음
                    return false
                case (true, true):
                    // 둘 다 있음 -> 값 비교
                    return dueDate != originalDueDate!
                default:
                    // 한쪽만 있음 -> 변경 있음
                    return true
                }
            }()
            let changed = (title != originalTitle)
                || (priority != originalPriority)
                || (status != originalStatus)
                || dueDateChanged

            return hasTitle && changed
        } else {
            // creating: enable only if title is present
            return hasTitle
        }
    }
}

#Preview {
    ModifyTaskView(task: nil)
}
