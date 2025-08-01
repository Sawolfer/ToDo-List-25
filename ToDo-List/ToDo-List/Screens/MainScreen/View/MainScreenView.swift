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

    @State var searchText: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var todos: FetchedResults<ToDoEntity>

    init() {
        _todos = FetchRequest(
            entity: ToDoEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \ToDoEntity.creationDate, ascending: true)]
        )
    }

    var tasksNumberLable: String {
        let number = todos.count

        if   (11...14).contains( number % 100 ) {
            return "\(number) Задач"
        }
        if number % 10 == 1 {
            return "\(number) Задача"
        }
        if number % 10 > 1, number % 10 < 5 {
            return "\(number) Задачи"
        }

        return "\(number) Задач"
    }

    var body: some View {
        ZStack {
            ScrollView{
                ForEach(todos) { todoTask in
                    ToDoEntityView(todoEntity: todoTask)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                toolBarItems
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("Задачи")
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
        }
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

        let mockTodos = ToDoEntity.generateMocks(count: 111, in: container.viewContext)

        NavigationStack {
            MainScreenView()
        }
        .preferredColorScheme(.dark)
        .environment(\.managedObjectContext, container.viewContext)
    }
}
