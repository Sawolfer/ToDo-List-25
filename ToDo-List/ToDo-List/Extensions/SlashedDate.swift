//
//  SlashedDate.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation

extension Date {
    var slashedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yy"
        return formatter.string(from: self)
    }
}
