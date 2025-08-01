//
//  RedactorScreenView.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import SwiftUI
import CoreData

struct RedactorScreenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var presenter: RedactorScreenPresenter

    @FocusState private var focusField: FieldFocus?

    enum FieldFocus {
        case title, content
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                taskTitleField
                dateLabel
                taskContentField
            }
        }
        .onAppear {
            presenter.setupViewContexxt(vc: viewContext)
        }
        .padding(20)
    }

    // MARK: - SubViews
    private var taskTitleField: some View {
        TextField(
            "Task Title",
            text: $presenter.taskTitle,
            axis: .vertical
        )
        .font(.system(size: 34).bold())
        .focused($focusField, equals: .title)
        .onSubmit {
            focusField = .content
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "chevron.left")
                    Text("Назад")
                }
                .foregroundStyle(.yellow)
                .onTapGesture {
                    presenter.onSave()
                    dismiss.callAsFunction()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var dateLabel: some View {
        Text(presenter.todoEntity.creationDate?.slashedDate ?? Date.now.slashedDate)
            .font(.caption)
            .fontWeight(.regular)
            .foregroundStyle(.secondary)
    }

    private var taskContentField: some View {
        ZStack {
            Color.clear
                .containerRelativeFrame(.vertical)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    focusField = .content
                }

            TextField(
                "Task content",
                text: $presenter.taskContent,
                axis: .vertical
            )
            .frame(
                maxHeight: .infinity,
                alignment: .top
            )
            .fontWeight(.regular)
            .focused($focusField, equals: .content)
        }
        .padding(.vertical, 8)
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: Preview Provider
struct RedactorScreenPreview: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        let container: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "ToDoModels")
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to load Core Data: \(error)")
                }
            }
            return container
        }()

        var todoEntity: ToDoEntity {
            let entity = ToDoEntity(context: container.viewContext)
            entity.id = UUID()
            entity.creationDate = Date.now
            entity.taskTitle = ""
            entity.taskContent = ""
            entity.isDone = false
            return entity
        }

        var body: some View {
            NavigationStack {
                RedactorScreenBuilder.build(todoEntity: todoEntity)
            }
            .preferredColorScheme(.dark)
        }
    }
}
