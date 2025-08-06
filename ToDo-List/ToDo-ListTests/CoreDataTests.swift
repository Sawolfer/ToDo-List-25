//
//  CoreDataTests.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 06.08.2025.
//

import Testing
import CoreData

@testable import ToDo_List

struct CoreDataTests {
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

    @Test
    func networkNCoreDataIntegrationTest() async throws {
        let context = container.viewContext
        let json = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "Test task",
                    "completed": false,
                    "userId": 1
                }
            ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = context

        let response = try decoder.decode(TodoResponse.self, from: json)
        try context.save()

        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        let results = try context.fetch(fetchRequest)
        let savedTodo = try #require(results.first)

        #expect(savedTodo.taskContent == "Test task")
        #expect(savedTodo.taskTitle == "API parsed Task")
        #expect(savedTodo.isDone == false)
    }

}
