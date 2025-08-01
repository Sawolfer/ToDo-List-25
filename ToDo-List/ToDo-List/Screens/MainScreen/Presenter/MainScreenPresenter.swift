//
//  MainScreenPresenter.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import SwiftUI

import CoreData

final class MainScreenPresenter: ObservableObject {
    @Published var searchText: String
    @Published var todoTasks: [ToDoEntity]
    @Published var filteredList: [ToDoEntity]

    var viewContext: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController<ToDoEntity>?

    // MARK: Init
    init() {
        self.searchText = ""
        self.todoTasks = []
        self.filteredList = []
    }

    // MARK: - Tasks logic
    func setupViewContext(vc: NSManagedObjectContext) {
        viewContext = vc
        setupFetchedResultsController()
    }
 
    func fetchTasks() {
        do {
            try fetchedResultsController?.performFetch()
            todoTasks = fetchedResultsController?.fetchedObjects ?? []
            filteredList = todoTasks
        } catch {
            print("Failed to fetch tasks: \(error)")
            todoTasks = []
        }
    }

    /// filter `filteredList` with new search string
    func filter() {
        let toSearch = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard toSearch != "" else  {
            filteredList = todoTasks
            return
        }

        filteredList = todoTasks.filter(
            {
                $0.taskTitle?.lowercased().contains(toSearch) ?? false ||
                $0.taskContent?.lowercased().contains(toSearch) ?? false
            }
        )
        filteredList.sort(by: { $0.creationDate! > $1.creationDate! })
    }

    func onCreateNew() {
        guard let viewContext else {
            return
        }
        let newTask = ToDoEntity(context: viewContext)
        newTask.id = UUID()
        newTask.isDone = false
        newTask.creationDate = Date.now

        todoTasks.append(newTask)
        filter()
    }
}

// MARK: - Private
private extension MainScreenPresenter {
    func setupFetchedResultsController() {
        guard let context = viewContext else { return }

        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ToDoEntity.creationDate, ascending: true)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
}
