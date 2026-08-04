//
//  ModifyTaskView.swift
//  TaskTracker
//
//  Created by picnic on 8/4/26.
//

import SwiftUI

struct ModifyTaskView: View {
    @State private var title: String = ""
    @State private var isDone: Bool = false
    
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
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // save
                        let task = Task(title: title, isDone: isDone)
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

#Preview {
    ModifyTaskView()
}
