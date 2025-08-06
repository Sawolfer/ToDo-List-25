//
//  NetworkLayerTests.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 06.08.2025.
//

import Testing
import CoreData

@testable import ToDo_List

struct NetworkLayerTests {
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
    func decoderTest() async throws {
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
        decoder.userInfo[.managedObjectContext] = container.viewContext

        let response = try decoder.decode(TodoResponse.self, from: json)
        let todoEntity = try #require(response.todos.first)

        #expect(todoEntity.taskContent == "Test task")
        #expect(todoEntity.taskTitle == "API parsed Task")
        #expect(todoEntity.isDone == false)
    }

    @Test
    func testMissingFields() async throws {
        let json = """
        {
            "todos": [
                {
                    "id": 1,
                    "completed": false
                }
            ]
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = container.viewContext

        #expect(throws: DecodingError.self) {
            _ = try decoder.decode(TodoResponse.self, from: json)
        }
    }

    @Test
    func testInvalidJSON() async throws {
        let invalidJson = Data([0, 1, 0, 1])

        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = container.viewContext

        #expect(throws: DecodingError.self) {
            _ = try decoder.decode(TodoResponse.self, from: invalidJson)
        }
    }
}
