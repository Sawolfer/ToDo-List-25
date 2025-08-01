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
            todo.taskContent = texts.randomElement()
            todo.isDone = Bool.random()
            todo.creationDate = Date().addingTimeInterval(Double(i) * 86400)
            return todo
        }
    }

    static var texts = [
        "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач",
        "Some text to check how it will look like in the view"
    ]
}
