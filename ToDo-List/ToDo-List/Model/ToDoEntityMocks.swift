//
//  ToDoEntityMocks.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import CoreData

extension ToDoEntity {
    static func generateMocks(count: Int, in context: NSManagedObjectContext) -> [ToDoEntity] {
        (1...count).map { i in
            let todo = ToDoEntity(context: context)
            todo.id = UUID()
            todo.taskTitle = "Task #\(i)"
            todo.isDone = Bool.random()
            todo.creationDate = Date().addingTimeInterval(Double(i) * 86400)
            return todo
        }
    }
}
