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

    @State var selected = false
    var onSelect: () -> Void

    var body: some View {
        bodyContent
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var bodyContent: some View {
        if selected {
            VStack {
                todoTaskInfo
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray4))
                    )
                contextMenu
                    .frame(width: 280)
            }
        } else {
            NavigationLink {
                RedactorScreenBuilder.build(todoEntity: todoEntity)
            } label: {
                HStack(alignment: .top, spacing: 8) {
                    completeButton
                    todoTaskInfo
                }
                .contentShape(Rectangle())
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .onLongPressGesture(minimumDuration: 0.3) {
                    onSelect()
                }
            }
        }
    }

    private var completeButton: some View {
        Image(systemName: todoEntity.isDone ? "checkmark.circle" : "circle")
            .font(.system(size: 24))
            .foregroundStyle(todoEntity.isDone ? .yellow : .secondary)
            .fontWeight(.light)
            .onTapGesture {
                todoEntity.isDone.toggle()
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

// MARK: - Conext Menu View
private extension ToDoEntityView {
    var contextMenu: some View {
        VStack {
            redactButton
            Divider()
            shareButton
            Divider()
            deleteButton
        }
        .padding(.vertical, 11)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.lightGray))
        )
    }

    var redactButton: some View {
        NavigationLink {
            RedactorScreenBuilder.build(todoEntity: todoEntity)
        } label: {
            HStack(spacing: 8) {
                Text("Редактировать")
                    .font(.body)
                Spacer()
                Image(systemName: "square.and.pencil")
            }
            .contentShape(Rectangle())
            .padding(.horizontal)
            .foregroundStyle(.black)
        }
    }

    var shareButton: some View {
        HStack(spacing: 8) {
            Text("Поделиться")
                .font(.body)
            Spacer()
            Image(systemName: "square.and.arrow.up")
        }
        .padding(.horizontal)
        .foregroundStyle(.black)
        .contentShape(Rectangle())
    }

    var deleteButton: some View {
        HStack(spacing: 8) {
            Text("Удалить")
                .font(.body)
            Spacer()
            Image(systemName: "trash")
        }
        .padding(.horizontal)
        .foregroundStyle(Color(red: 215/255, green: 0, blue: 21/255))
        .contentShape(Rectangle())
    }
}

struct PlaceHolderView: View {

    @State var name: String

    var body: some View {
        Text(name)
    }
}
