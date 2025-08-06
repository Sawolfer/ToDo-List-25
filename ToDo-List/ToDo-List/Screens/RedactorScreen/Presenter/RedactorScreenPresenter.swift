//
//  RedactorScreenPresenter.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import SwiftUI

import CoreData

protocol RedactorScreenPresenterProtocol: ObservableObject {
    var todoEntity: ToDoEntity { get set }
    var taskTitle: String { get set }
    var taskContent: String { get set}

    func setupViewContexxt(vc: NSManagedObjectContext)
    func onSave()
}

final class RedactorScreenPresenter: RedactorScreenPresenterProtocol {
    @ObservedObject var todoEntity: ToDoEntity
    @Published var taskTitle: String
    @Published var taskContent: String

    private var interactor: RedactorScreenInteractorProtocol

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
        interactor.setupViewContext(vc)
    }

    func onSave() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            if taskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, let oldTitle = todoEntity.taskTitle {
                taskTitle = oldTitle
            }

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
