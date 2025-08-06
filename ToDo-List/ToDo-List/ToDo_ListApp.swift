//
//  ToDo_ListApp.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 31.07.2025.
//

import SwiftUI
import CoreData

@main
struct ToDo_ListApp: App {

    let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModels")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error)")
            }
        }
        return container
    }()

    var body: some Scene {
        WindowGroup {
            MainScreenBuilder.build()
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, container.viewContext)
        }
    }
}
