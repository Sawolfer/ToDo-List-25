//
//  ToDoEntityView.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 01.08.2025.
//

import Foundation
import SwiftUI

struct ToDoEntityView: View {

    @ObservedObject var todoEntity: ToDoEntity

    var slashedDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/mm/yy"
        return formatter
    }

    var body: some View {
        NavigationLink{
            PlaceHolderView(name: todoEntity.taskTitle!)
        } label: {
            HStack(alignment: .top) {
                completeButton
                todoTaskInfo
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
        .buttonStyle(.plain)
    }

    private var completeButton: some View {
        Image(systemName: todoEntity.isDone ? "checkmark.circle" : "circle")
            .onTapGesture {
                todoEntity.isDone.toggle()
                print(todoEntity.isDone)
            }
    }

    private var todoTaskInfo: some View {
        VStack(alignment: .leading) {
            Text(todoEntity.taskTitle!)
            Text(todoEntity.taskContent ?? "")
            Text(slashedDateFormatter.string(from: todoEntity.creationDate!))
        }
    }
}

struct PlaceHolderView: View {

    @State var name: String

    var body: some View {
        Text(name)
    }
}
