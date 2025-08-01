//
//  MainScreenBuilder.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation

enum MainScreenBuilder{
    static func build (

    ) -> MainScreenView {
        let presenter = MainScreenPresenter()

        return MainScreenView(presenter: presenter)
    }
}
