//
//  RedactorScreenPresenter.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import SwiftUI

import CoreData

final class RedactorScreenPresenter: ObservableObject {
    @ObservedObject var todoEntity: ToDoEntity
    @Published var taskTitle: String
    @Published var taskContent: String

    private var interactor: RedactorScreenInteractor

    init(
        todoEntity: ToDoEntity,
        interactor: RedactorScreenInteractor
    ) {
        self.todoEntity = todoEntity
        self.taskTitle = todoEntity.taskTitle ?? ""
        self.taskContent = todoEntity.taskContent ?? ""

        self.interactor = interactor
    }

    func setupViewContexxt(vc: NSManagedObjectContext) {
        interactor.context = vc
    }

    func onSave() {
        DispatchQueue.main.async { [self] in
            do {
                try interactor.save(
                    todoEntity: todoEntity,
                    newTitle: taskTitle,
                    newContent: taskContent
                )
            } catch {
                print("Error while saving task: \(error)")
            }
        }
    }
}
