//
//  RedactorScreenInteractor.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import CoreData

protocol RedactorScreenInteractorProtocol: AnyObject {
    func save(todoEntity: ToDoEntity, newTitle: String, newContent: String) throws
    func setupViewContext(_ context: NSManagedObjectContext)
}

final class RedactorScreenInteractor: RedactorScreenInteractorProtocol {
    var context: NSManagedObjectContext?

    func setupViewContext(_ context: NSManagedObjectContext) {
        self.context = context
    }

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
