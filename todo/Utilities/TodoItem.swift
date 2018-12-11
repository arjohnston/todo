//
//  TodoItem.swift
//  todo
//
//  Created by Andrew Johnston on 12/2/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import Foundation

class TodoItem: NSObject, Codable {
    var title: String = ""
    var itemDescription: String = ""
    var checked: Bool = false
    var priority: Int = TodoList.Priority.none.rawValue
    
    init(title: String, itemDescription: String, checked: Bool, priority: TodoList.Priority.RawValue) {
        self.title = title
        self.itemDescription = itemDescription
        self.checked = checked
        self.priority = priority
        
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let itemDescription = aDecoder.decodeObject(forKey: "itemDescription") as! String
        let checked = aDecoder.decodeBool(forKey: "checked")
        let priority = aDecoder.decodeObject(forKey: "priority") as! TodoList.Priority.RawValue
    
        self.init(title: title, itemDescription: itemDescription, checked: checked, priority: priority)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(itemDescription, forKey: "itemDescription")
        aCoder.encode(checked, forKey: "checked")
        aCoder.encode(priority, forKey: "priority")
    }
}
