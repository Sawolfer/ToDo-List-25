//
//  FirstCallChecker.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 05.08.2025.
//

import Foundation

final class FirstCallChecker {
    static let defaults = UserDefaults.standard


    static func setValue() {
        let encoder = JSONEncoder()

        let data = try? encoder.encode(true)

        defaults.set(data, forKey: "firstCall")
    }

    static func getValue() -> Bool {
        guard let savedData = defaults.object(forKey: "firstCall") as? Data else {
            return false
        }

        let decoder = JSONDecoder()

        guard let value = try? decoder.decode(Bool.self, from: savedData) else {
            return false
        }
        
        return value
    }

    static func cleanValue() {
        defaults.removeObject(forKey: "firstCall")
    }
}
