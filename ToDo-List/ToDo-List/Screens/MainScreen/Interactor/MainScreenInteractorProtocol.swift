protocol MainScreenInteractorProtocol: AnyObject {
    func setupViewContext(_ context: NSManagedObjectContext)
    func fetchTasks() -> [ToDoEntity]
    func createNewTask() throws -> ToDoEntity
    func deleteTask(_ task: ToDoEntity) throws
    func saveChanges()
    func filterTasks(_ tasks: [ToDoEntity], searchText: String) -> [ToDoEntity]
}

final class MainScreenInteractor: MainScreenInteractorProtocol {
    private var viewContext: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController<ToDoEntity>?
    
    func setupViewContext(_ context: NSManagedObjectContext) {
        self.viewContext = context
        setupFetchedResultsController()
    }
    
    func fetchTasks() -> [ToDoEntity] {
        guard let context = viewContext else { return [] }
        
        do {
            try fetchedResultsController?.performFetch()
            let tasks = fetchedResultsController?.fetchedObjects ?? []
            return tasks.sorted { ($0.creationDate ?? Date()) > ($1.creationDate ?? Date()) }
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func createNewTask() throws -> ToDoEntity {
        guard let context = viewContext else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No context available"])
        }
        
        let newTask = ToDoEntity(context: context)
        newTask.id = UUID()
        newTask.isDone = false
        newTask.creationDate = Date()
        try context.save()
        return newTask
    }
    
    func deleteTask(_ task: ToDoEntity) throws {
        guard let context = viewContext else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No context available"])
        }
        
        context.delete(task)
        try context.save()
    }
    
    func saveChanges() {
        guard let context = viewContext, context.hasChanges else { return }
        try? context.save()
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
        
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ToDoEntity.creationDate, ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
}