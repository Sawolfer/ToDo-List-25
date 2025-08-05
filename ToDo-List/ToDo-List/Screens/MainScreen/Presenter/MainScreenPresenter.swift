//
//  MainScreenPresenter.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import SwiftUI

import CoreData

protocol MainScreenPresenterProtocol: ObservableObject {
    var searchText: String { get set }
    var todoTasks: [ToDoEntity] { get }
    var filteredList: [ToDoEntity] { get }
    var navigateNewTask: ToDoEntity? { get set }
    var shouldNavigateToTask: Bool { get set }

    func setupViewContext(_ context: NSManagedObjectContext)
    func fetchTasks()
    func filter()
    func onCreateNew()
    func onDelete(_ task: ToDoEntity)
    func clearEmpty()
    func saveData()
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    @Published var searchText: String = ""
    @Published private(set) var todoTasks: [ToDoEntity] = []
    @Published private(set) var filteredList: [ToDoEntity] = []
    @Published var navigateNewTask: ToDoEntity? = nil
    @Published var shouldNavigateToTask: Bool = false

    private let interactor: MainScreenInteractorProtocol

    init(interactor: MainScreenInteractorProtocol = MainScreenInteractor()) {
        self.interactor = interactor
    }

    func setupViewContext(_ context: NSManagedObjectContext) {
        interactor.setupViewContext(context)

        syncWithAPI()
    }

    func fetchTasks() {
        todoTasks = interactor.fetchTasks()
        filteredList = todoTasks
        clearEmpty()
    }

    func syncWithAPI() {
        if FirstCallChecker.getValue() { return }

        interactor.makeRequest { result in
            switch result {
                case .success(_):
                    FirstCallChecker.setValue()
                    self.fetchTasks()
                case .failure(let error):
                    print(error)
            }
        }
    }

    func filter() {
        filteredList = interactor.filterTasks(todoTasks, searchText: searchText)
    }

    func onCreateNew() {
        do {
            let newTask = try interactor.createNewTask()
            todoTasks.insert(newTask, at: 0)
            filter()
            navigateNewTask = newTask
            shouldNavigateToTask = true
        } catch {
            print("Create error: \(error)")
        }
    }

    func onDelete(_ task: ToDoEntity) {
        do {
            try interactor.deleteTask(task)
            fetchTasks()
        } catch {
            print("Delete error: \(error)")
        }
    }

    func clearEmpty() {
        let emptyTasks = todoTasks.filter {
            $0.taskTitle?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        }

        emptyTasks.forEach { task in
            try? interactor.deleteTask(task)
        }

        todoTasks.removeAll(where: {emptyTasks.contains($0)})
        filter()
    }

    func saveData() {
        interactor.saveChanges()
    }
}
