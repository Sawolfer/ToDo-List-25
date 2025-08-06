//
//  MainScreenInteractorProtocol.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 04.08.2025.
//

import CoreData

protocol MainScreenInteractorProtocol: AnyObject {
    func setupViewContext(_ context: NSManagedObjectContext)
    func fetchTasks() -> [ToDoEntity]
    func makeRequest(completion: @escaping (Result<Bool, Error>) -> Void)
    func createNewTask(completion: @escaping (Result<ToDoEntity, Error>) -> Void)
    func deleteTask(_ task: ToDoEntity, completion: @escaping (Error?) -> Void)
    func saveChanges()
    func filterTasks(_ tasks: [ToDoEntity], searchText: String) -> [ToDoEntity]
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    private var viewContext: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController<ToDoEntity>?

    private let backgroundQueue = DispatchQueue(
        label: "com.todos.backgroundQueue",
        qos: .userInitiated
    )

    func setupViewContext(_ context: NSManagedObjectContext) {
        self.viewContext = context
        setupFetchedResultsController()
    }

    func makeRequest(completion: @escaping (Result<Bool, Error>) -> Void) {
        let networkLayer = NetworkLayer(context: viewContext!)

        networkLayer.getToDos { result in
            switch result {
                case .success(let todos):
                    todos.forEach { todo in
                        self.viewContext?.insert(todo)
                    }
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        
        saveChanges()
    }

    func fetchTasks() -> [ToDoEntity] {
        guard viewContext != nil else { return [] }
        
        do {
            try fetchedResultsController?.performFetch()
            let tasks = fetchedResultsController?.fetchedObjects ?? []
            return tasks.sorted { ($0.creationDate ?? Date()) > ($1.creationDate ?? Date())}
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func createNewTask(completion: @escaping (Result<ToDoEntity, Error>) -> Void) {
        backgroundQueue.async {
            guard let context = self.viewContext else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No context available"])))
                }
                return
            }

            let newTask = ToDoEntity(context: context)
            newTask.id = UUID()
            newTask.isDone = false
            newTask.creationDate = Date()

            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(newTask))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteTask(_ task: ToDoEntity, completion: @escaping (Error?) -> Void) {
        backgroundQueue.async {
            guard let context = self.viewContext else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No context available"]))
                return 
            }

            context.delete(task)
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func saveChanges() {
        guard let context = self.viewContext, context.hasChanges else { return }
        context.perform {
            try? context.save()
        }
    }
    
    func filterTasks(_ tasks: [ToDoEntity], searchText: String) -> [ToDoEntity] {
        guard !searchText.isEmpty else { return tasks }
        
        let query = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return tasks.filter {
            $0.taskTitle?.lowercased().contains(query) ?? false ||
            $0.taskContent?.lowercased().contains(query) ?? false
        }.sorted {
            ($0.creationDate ?? Date()) > ($1.creationDate ?? Date())
        }
    }
    
    private func setupFetchedResultsController() {
        guard let context = viewContext else { return }

        let request = ToDoEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ToDoEntity.creationDate, ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    enum SavingError: Error {
        case emptyViewContext
    }
}
