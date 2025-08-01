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
            HStack(alignment: .top, spacing: 8) {
                completeButton
                todoTaskInfo
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .buttonStyle(.plain)
    }

    private var completeButton: some View {
        Image(systemName: todoEntity.isDone ? "checkmark.circle" : "circle")
            .font(.system(size: 24))
            .foregroundStyle(todoEntity.isDone ? .yellow : .secondary)
            .fontWeight(.light)
            .onTapGesture {
                todoEntity.isDone.toggle()
                print(todoEntity.isDone)
            }
    }

    private var todoTaskInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(todoEntity.taskTitle!)
                .font(.system(size: 16))
                .strikethrough(todoEntity.isDone)
                .fontWeight(.medium)
                .foregroundStyle(todoEntity.isDone ? .secondary : .primary)
            Text(todoEntity.taskContent ?? "")
                .font(.caption)
                .foregroundStyle(todoEntity.isDone ? .secondary : .primary)
                .lineLimit(2)
            Text(slashedDateFormatter.string(from: todoEntity.creationDate!))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct PlaceHolderView: View {

    @State var name: String

    var body: some View {
        Text(name)
    }
}
