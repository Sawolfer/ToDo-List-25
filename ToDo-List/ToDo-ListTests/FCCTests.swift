//
//  ToDo_ListTests.swift
//  ToDo-ListTests
//
//  Created by Савва Пономарев on 05.08.2025.
//

import Testing

@testable import ToDo_List

struct Test_FirstCallChecker {
    @Test
    func checkForFCCFailuer() throws {
        FirstCallChecker.cleanValue()
        let check = FirstCallChecker.getValue()

        #expect(check == false)
    }

    @Test
    func checkForFCCSuccess() throws {
        FirstCallChecker.setValue()

        let check = FirstCallChecker.getValue()
        #expect(check == true)
    }
}
