//
//  MainScreenView.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import SwiftUI

import CoreData

struct MainScreenView: View {
    @ObservedObject var presenter: MainScreenPresenter

    @Environment(\.managedObjectContext) private var viewContext

    private var tasksNumberLable: String {
        let number = presenter.todoTasks.count

        if (11...14).contains( number % 100 ) {
            return "\(number) Задач"
        }
        switch number % 10 {
            case 1:
                return "\(number) Задача"
            case (2...4):
                return "\(number) Задачи"
            default:
                return "\(number) Задач"
        }
    }

    var body: some View {
        ScrollView{
            LazyVStack {
                ForEach(presenter.filteredList) { todoTask in
                    ToDoEntityView(todoEntity: todoTask)

                    if todoTask.id != presenter.filteredList.last?.id {
                        dividerLine
                    }
                }
            }
        }
        .onDisappear {
            presenter.saveData()
        }
        .onAppear {
            presenter.setupViewContext(vc: viewContext)
            presenter.fetchTasks()
            presenter.clearEmpty()
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                toolBarItems
            }
        }
        .searchable(text: $presenter.searchText)
        .onChange(of: presenter.searchText){
            presenter.filter()
        }
        .navigationDestination(isPresented: $presenter.shouldNavigateToTask) {
           if let task = presenter.navigateNewTask {
               RedactorScreenBuilder.build(todoEntity: task)
           }
       }
        .navigationTitle("Задачи")
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - SubViews
    private var toolBarItems: some View {
        ZStack {
            Text(tasksNumberLable)
                .font(.system(size: 11))
                .fontWeight(.regular)
                .frame(
                    maxWidth: .infinity,
                    alignment: .center
                )
            Image(systemName: "square.and.pencil")
                .foregroundStyle(.yellow)
                .font(.system(size: 22))
                .fontWeight(.regular)
                .frame(
                    maxWidth: .infinity,
                    alignment: .trailing
                )
                .onTapGesture {
                    presenter.onCreateNew()
                }
        }
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(.secondary)
            .frame(
                height: 1
            )
            .padding(.horizontal, 20)
    }
}

// MARK: - Preview Provider
struct MainScreenPreview: PreviewProvider {
    static var previews: some View {
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

        let mockTodos = ToDoEntity.generateMocks(count: 2, in: container.viewContext)

        NavigationStack {
            MainScreenBuilder.build()
        }
        .preferredColorScheme(.dark)
        .environment(\.managedObjectContext, container.viewContext)
    }
}
