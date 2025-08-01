//
//  RedactorScreenBuilder.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation

enum RedactorScreenBuilder{
    static func build(
        todoEntity: ToDoEntity
    ) -> RedactorScreenView {
        let interactor = RedactorScreenInteractor()
        let presenter = RedactorScreenPresenter(
            todoEntity: todoEntity,
            interactor: interactor
        )

        return RedactorScreenView(presenter: presenter)
    }
}
