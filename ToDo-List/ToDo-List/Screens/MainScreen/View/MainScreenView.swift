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
    @State var selectedTask: UUID? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                mainContentLayer

                selectedTaskLayer

                tapDismissLayer
            }
            .onDisappear {
                presenter.saveData()
            }
            .onAppear {
                selectedTask = nil
                setupPresenter()
            }
            .onChange(of: presenter.searchText){
                presenter.filter()
            }
            .navigationDestination(isPresented: $presenter.shouldNavigateToTask) {
                if let task = presenter.navigateNewTask {
                    RedactorScreenBuilder.build(todoEntity: task)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
    }
}

// MARK: - SubViews
private extension MainScreenView {
    var tasksNumberLable: String {
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

    var mainContentLayer: some View {
        NavigationView {
            ScrollView{
                LazyVStack {
                    ForEach(presenter.filteredList) { todoTask in
                        if !isSelected(task: todoTask) {
                            ToDoEntityView(
                                todoEntity: todoTask,
                                onSelect:  {
                                selectTask(todoTask)
                            })

                            if !isLast(task: todoTask) {
                                dividerLine
                            }
                        }
                    }
                    .id(presenter.todoTasks.count)
                }
            }
            .toolbar { bottomToolbar }
            .navigationTitle("Задачи")
        }
        .searchable(text: $presenter.searchText)
        .blur(radius: selectedTask != nil ? 2 : 0)
        .disabled(selectedTask != nil)
    }

    var selectedTaskLayer: some View {
        Group {
            if let selectedTask,
               let task = presenter.filteredList.first(where: { $0.id == selectedTask }) {
                ToDoEntityView(
                    todoEntity: task,
                    selected: true,
                    onSelect:  {
                        deselectTask()
                    },
                    onDelete: {
                        deselectTask()
                        presenter.onDelete(todoEntity: task)
                    }
                )
                .zIndex(1)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 10)
                .transition(.scale)
            }
        }
        .frame(
            alignment: .centerLastTextBaseline
        )
    }

    var tapDismissLayer: some View {
        Group {
            if selectedTask != nil {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        deselectTask()
                    }
                    .zIndex(0)
            }
        }
    }

    var bottomToolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            toolBarItems
        }
    }

    var toolBarItems: some View {
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

    var dividerLine: some View {
        Rectangle()
            .fill(.secondary)
            .frame(
                height: 1
            )
            .padding(.horizontal, 20)
    }
}

// MARK: - Private Functions
private extension MainScreenView {
    func isSelected(task: ToDoEntity) -> Bool {
        selectedTask == task.id
    }

    func isLast(task: ToDoEntity) -> Bool {
        task.id == presenter.filteredList.last?.id
    }

    func selectTask(_ task: ToDoEntity) {
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedTask = task.id
        }
    }

    func deselectTask() {
        withAnimation {
            selectedTask = nil
        }
    }

    func setupPresenter() {
        presenter.setupViewContext(vc: viewContext)
        presenter.fetchTasks()
        presenter.clearEmpty()
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


        MainScreenBuilder.build()
            .preferredColorScheme(.dark)
            .environment(\.managedObjectContext, container.viewContext)
    }
}
