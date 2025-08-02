//
//  RedactorScreenInteractor.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import CoreData

final class RedactorScreenInteractor {
    var context: NSManagedObjectContext?

    func save(todoEntity: ToDoEntity, newTitle: String, newContent: String) throws {
        guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw SaveError.emptyTitle
        }

        todoEntity.taskTitle = newTitle
        todoEntity.taskContent = newContent.isEmpty ? nil : newContent
    }
    
    enum SaveError: Error {
        case emptyTitle
        case emptyViewContext
        case coreDataError(Error)
    }
}
