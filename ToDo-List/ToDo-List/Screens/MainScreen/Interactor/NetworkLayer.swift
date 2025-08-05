//
//  NetworkLayer.swift
//  ToDo-List
//
//  Created by Савва Пономарев on 04.08.2025.
//

import Foundation
import CoreData

protocol NetworkLayerProtocol {
//    func getToDos(completion: @escaping (Result<[ToDoEntity], Error>) -> Void)
}

final class NetworkLayer: NetworkLayerProtocol {

    private let baseURL = "https://dummyjson.com/todos"
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

//    func getToDos(completion: @escaping (Result<[ToDoEntity], Error>) -> Void){
//        guard let url = URL(string: baseURL) else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        let networkCallItem = DispatchWorkItem {
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                    return
//                }
//
//                guard let data = data else {
//                    DispatchQueue.main.async {
//                        completion(.failure(NetworkError.noData))
//                    }
//                    return
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.userInfo[.managedObjectContext] = self.context
//
//                    let response = try decoder.decode(TodoResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(response.todos))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                }
//            }.resume()
//        }
//
//        DispatchQueue.global(qos: .background).async(execute: networkCallItem)
//    }

    enum NetworkError: Error {
        case invalidURL
        case noData
    }

//    struct TodoResponse: Decodable {
//        let todos: [ToDoEntity]
//    }
}
