//
//  TodoList.swift
//  todo
//
//  Created by Andrew Johnston on 12/3/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Foundation

class TodoList {
    enum Priority: Int, CaseIterable {
        case high, medium, low, none, completed
    }
    
    private var highPriorityTodos: [TodoItem] = []
    private var mediumPriorityTodos: [TodoItem] = []
    private var lowPriorityTodos: [TodoItem] = []
    private var noPriorityTodos: [TodoItem] = []
    private var completedTodos: [TodoItem] = []
    
    init() {
        load()
    }
    
    func save() {
        var todos: [TodoItem] = []
        
        for todo in highPriorityTodos {
            todos.append(todo)
        }
        for todo in mediumPriorityTodos {
            todos.append(todo)
        }
        for todo in lowPriorityTodos {
            todos.append(todo)
        }
        for todo in noPriorityTodos {
            todos.append(todo)
        }
        for todo in completedTodos {
            todos.append(todo)
        }

        FileManager().saveTodos(todos: todos)
    }
    
    func load() {
        let todos = FileManager().loadTodos()
        
        for todo in todos {
            if todo.checked {
                completedTodos.append(todo)
            } else {
                switch todo.priority {
                case Priority.high.rawValue:
                    highPriorityTodos.append(todo)
                case Priority.medium.rawValue:
                    mediumPriorityTodos.append(todo)
                case Priority.low.rawValue:
                    lowPriorityTodos.append(todo)
                case Priority.none.rawValue:
                    noPriorityTodos.append(todo)
                default:
                    completedTodos.append(todo)
                }
            }
        }
    }
    
    func todoList(for priority: Priority) ->[TodoItem] {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .none:
            return noPriorityTodos
        case .completed:
            return completedTodos
        }
    }
    
    func addTodo(_ item: TodoItem, at index: Int = -1) {
        if item.checked {
            completedTodos.append(item)
            
            return
        }
        
        switch item.priority {
        case TodoList.Priority.high.rawValue:
            if index < 0 {
                highPriorityTodos.append(item)
            } else {
                highPriorityTodos.insert(item, at: index)
            }
        case TodoList.Priority.medium.rawValue:
            if index < 0 {
                mediumPriorityTodos.append(item)
            } else {
                mediumPriorityTodos.insert(item, at: index)
            }
        case TodoList.Priority.low.rawValue:
            if index < 0 {
                lowPriorityTodos.append(item)
            } else {
                lowPriorityTodos.insert(item, at: index)
            }
        case TodoList.Priority.none.rawValue:
            if index < 0 {
                noPriorityTodos.append(item)
            } else {
                noPriorityTodos.insert(item, at: index)
            }
        default:
            if index < 0 {
                completedTodos.append(item)
            } else {
                completedTodos.insert(item, at: index)
            }
        }
    }
    
    func move(item: TodoItem, from sourcePriority: Priority, at sourceIndex: Int, to destinationPriority: Priority, at destinationIndex: Int = -1) {
        remove(item, from: sourcePriority, at: sourceIndex)
        
        if destinationPriority != .completed {
            item.priority = destinationPriority.rawValue
        } else if destinationPriority == .completed && !item.checked {
            item.priority = destinationPriority.rawValue
            item.checked = true
        }
        
        addTodo(item, at: destinationIndex)
    }
    
    func remove(_ item: TodoItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .none:
            noPriorityTodos.remove(at: index)
        case .completed:
            completedTodos.remove(at: index)
        }
    }
    
    func getPriorityTodoCount(for priority: TodoList.Priority) -> Int {
        switch priority {
        case .high:
            return highPriorityTodos.count
        case .medium:
            return mediumPriorityTodos.count
        case .low:
            return lowPriorityTodos.count
        case .none:
            return noPriorityTodos.count
        case .completed:
            return completedTodos.count
        }
    }
    
    func getItemIndexInPriority(for item: TodoItem, in priority: TodoList.Priority) -> Int {
        switch priority {
        case .high:
            return highPriorityTodos.index(of: item)!
        case .medium:
            return mediumPriorityTodos.index(of: item)!
        case .low:
            return lowPriorityTodos.index(of: item)!
        case .none:
            return noPriorityTodos.index(of: item)!
        case .completed:
            return completedTodos.index(of: item)!
        }
    }
}
