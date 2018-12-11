//
//  AddItemTableViewController.swift
//  todo
//
//  Created by Andrew Johnston on 12/3/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewControllerDidAdd(_ controller: ItemDetailViewController, didFinishAdding item: TodoItem, for priority: TodoList.Priority)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: TodoItem)
}

class ItemDetailViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    weak var delegate: ItemDetailViewControllerDelegate?
    weak var todoList: TodoList?
    weak var itemToEdit: TodoItem?
    var itemIndex: Int?
    var pickerMenuItems: [String] = [String]()
    var keyboardIsOpen: Bool = false
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var priorityPickerMenu: UIPickerView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize picker menu
        for item in TodoList.Priority.allCases {
            pickerMenuItems.append(getPriorityString(item))
        }
        
        priorityPickerMenu.delegate = self
        priorityPickerMenu.dataSource = self

        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.title
            descriptionTextField.text = item.itemDescription
            addBarButton.isEnabled = true
            priorityPickerMenu.selectRow(pickerMenuItems.index(of: getPriorityString(TodoList.Priority(rawValue: item.priority)!))!, inComponent: 0, animated: true)
        } else {
            // Default to "none"
            let noPriority = pickerMenuItems.index(of: "none")
            priorityPickerMenu.selectRow(noPriority!, inComponent: 0, animated: true)
        }
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerMenuItems.count
    }

    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerMenuItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Automatically open the keyboard when the view appears
        textField.becomeFirstResponder()
    }

    @IBAction func cancel(_ sender: Any) {
        // Pop off view, discarding any changes/additions
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    // Finish adding or editing an item
    @IBAction func done(_ sender: Any) {
        // If an item is passed into the view, edit that item
        let selectedRowInPickerMenu: String = pickerMenuItems[priorityPickerMenu.selectedRow(inComponent: 0)]
        if let item = itemToEdit,
           let text = textField.text,
           let itemDescription = descriptionTextField.text {
            item.title = text
            item.itemDescription = itemDescription
            
            let newPriority = getPriorityRawValue(selectedRowInPickerMenu)
            
            item.priority = newPriority.rawValue
    
            delegate?.itemDetailViewController(self, didFinishEditing: item)
            
        // Otherwise add a new item
        } else {
            if let textFieldText = textField.text,
               let itemDescription = descriptionTextField.text {
                let title = textFieldText
                let priority = getPriorityRawValue(selectedRowInPickerMenu)
                
                let item = TodoItem(title: title, itemDescription: itemDescription, checked: false, priority: priority.rawValue)
                
                let selectedRowIndex: Int = priorityPickerMenu.selectedRow(inComponent: 0)
                todoList?.addTodo(item)
                delegate?.itemDetailViewControllerDidAdd(self, didFinishAdding: item, for: TodoList.Priority(rawValue: selectedRowIndex)!)
            }
            
        }
    }
    
    // Prevent user from selecting table cell when tapping the text field
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func getPriorityString(_ priority: TodoList.Priority) -> String {
        switch priority {
        case .high:
            return "high"
        case .medium:
            return "medium"
        case .low:
            return "low"
        case .none:
            return "none"
        case .completed:
            return "completed"
        }
    }
    
    func getPriorityRawValue(_ priority: String) -> TodoList.Priority {
        switch priority {
        case "high":
            return TodoList.Priority.high
        case "medium":
            return TodoList.Priority.medium
        case "low":
            return TodoList.Priority.low
        case "none":
            return TodoList.Priority.none
        default:
            return TodoList.Priority.completed
        }
    }
}

extension ItemDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Closes the keyboard once Done is pressed
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Disables the Add button if no text in textField
        guard let oldText = textField.text,
              let stringRange = Range(range, in: oldText) else {
                return false
        }
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        addBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
}

extension ItemDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextField.isFirstResponder && self.view.frame.origin.y == 0 {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.frame.origin.y -= 60
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !descriptionTextField.isFirstResponder && self.view.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.view.frame.origin.y = 0
            })
        }
    }
}
