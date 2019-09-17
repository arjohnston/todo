//
//  FileManager+extensions.swift
//  todo
//
//  Created by Andrew Johnston on 12/8/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    func saveTodos(todos: [TodoItem]) {
//        // Create a url for documents-directory/todos.json
//        let url = getDocumentsDirectory().appendingPathComponent("todos.json")
//        // Encode [TodoItem] data to JSON Data
//        let encoder = JSONEncoder()
//        do {
//            let data = try encoder.encode(todos)
//            // Check if todos.json already exists
//            if FileManager().fileExists(atPath: url.path) {
//                // If the file exists, remove it
//                try FileManager().removeItem(at: url)
//            }
//            // Create todos.json with the data
//            FileManager().createFile(atPath: url.path, contents: data, attributes: nil)
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
    
    func saveLists(lists: [[TodoItem]]) {
        // Create a url for documents-directory/todos.json
        let url = getDocumentsDirectory().appendingPathComponent("lists.json")
        // Encode [TodoItem] data to JSON Data
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(lists)
            // Check if lists.json already exists
            if FileManager().fileExists(atPath: url.path) {
                // If the file exists, remove it
                try FileManager().removeItem(at: url)
            }
            // Create lists.json with the data
            FileManager().createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func loadLists() -> [[TodoItem]] {
        // Create a url for documents-directory/todos.json
        let url = getDocumentsDirectory().appendingPathComponent("lists.json")
        var lists: [[TodoItem]] = []
        
        // Make sure lists.json exists
        if !FileManager().fileExists(atPath: url.path) {
            print("No todos to get, todos.json does not exist")
        }
        
        // Retrieve that data
        if let data = FileManager().contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                // Decode an array of TodoItems
                lists = try decoder.decode([[TodoItem]].self, from: data)
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            print("No data retrieved from lists.json")
        }
        
        return lists
    }
    
//    func loadTodos() -> [TodoItem] {
//        // Create a url for documents-directory/todos.json
//        let url = getDocumentsDirectory().appendingPathComponent("todos.json")
//        var todos: [TodoItem] = []
//
//        // Make sure todos.json exists
//        if !FileManager().fileExists(atPath: url.path) {
//            print("No todos to get, todos.json does not exist")
//        }
//
//        // Retrieve that data
//        if let data = FileManager().contents(atPath: url.path) {
//            let decoder = JSONDecoder()
//            do {
//                // Decode an array of TodoItems
//                todos = try decoder.decode([TodoItem].self, from: data)
//            } catch {
//                fatalError(error.localizedDescription)
//            }
//        } else {
//            print("No data retrieved from todos.json")
//        }
//
//        return todos
//    }
}


