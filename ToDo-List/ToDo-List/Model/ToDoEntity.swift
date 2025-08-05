
@objc(ToDoEntity)
public class ToDoEntity: NSManagedObject, Decodable {
    @NSManaged public var id: UUID?
    @NSManaged public var isDone: Bool
    @NSManaged public var creationDate: Date?
    @NSManaged public var taskTitle: String?
    @NSManaged public var taskContent: String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case taskContent = "todo"
        case isDone = "completed"
    }

    required convenience public init(from decoder: any Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.init(context: context)

        id = try container.decode(UUID.self, forKey: .id)
        isDone = try container.decode(Bool.self, forKey: .isDone)
        creationDate = Date.now
        taskTitle = "API parsed Task"
        taskContent = try container.decode(String.self, forKey: .taskContent)
    }

    enum DecoderConfigurationError: Error {
      case missingManagedObjectContext
    }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
