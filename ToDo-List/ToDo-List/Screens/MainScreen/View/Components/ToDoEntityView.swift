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
    
    var body: some View {
        NavigationLink{
            RedactorScreenBuilder.build(todoEntity: todoEntity)
        } label: {
            HStack(alignment: .top, spacing: 8) {
                completeButton
                todoTaskInfo
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(
                Rectangle()
                    .fill(.clear)
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
            Text(todoEntity.taskTitle ?? "New ToDo")
                .font(.system(size: 16))
                .strikethrough(todoEntity.isDone)
                .fontWeight(.medium)
                .foregroundStyle(todoEntity.isDone ? .secondary : .primary)
            Text(todoEntity.taskContent ?? "")
                .font(.caption)
                .foregroundStyle(todoEntity.isDone ? .secondary : .primary)
                .lineLimit(2)
            Text(todoEntity.creationDate?.slashedDate ?? Date.now.slashedDate)
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
