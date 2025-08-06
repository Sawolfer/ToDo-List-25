//
//  ToDoEntity.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 05.08.2025.
//

import Foundation
import CoreData

//@objc(ToDoEntity)
public class ToDoEntity: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case taskContent = "todo"
        case isDone = "completed"
    }

    required convenience public init(from decoder: any Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.isDone = try container.decode(Bool.self, forKey: .isDone)
        self.creationDate = Date.now
        self.taskTitle = "API parsed Task"
        self.taskContent = try container.decode(String.self, forKey: .taskContent)
    }

    enum DecoderConfigurationError: Error {
      case missingManagedObjectContext
    }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

