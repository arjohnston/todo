//
//  ViewController.swift
//  todo
//
//  Created by Andrew Johnston on 12/1/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//


// The top left of the nav bar should be a back button that takes you to a new home screen to select projects
// Improve the autolayout for 8 / 8+
// Keyboard should dynamically change height of view on itemdetailview
// Move cells without being in edit mode. Gesture up / down. Long press & move
// Add edit btn on collection view to remove selected cells


import UIKit

class TodoViewController: UITableViewController {
    weak var todoList: TodoList?

    var shouldEditMenuItemsBeShown: Bool = false
    
    var navigationItemEditableTitleTextField = UITextField()
    
    @IBOutlet weak var addToolbarButton: UIBarButtonItem!
    @IBOutlet weak var editListButton: UIBarButtonItem!
    @IBOutlet weak var deleteListItemsButton: UIBarButtonItem!
    
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }
    
    
    // When at least one item is selected in the "Edit" menu
    // the Trash button deletes those items.
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todos = todoList!.todoList(for: priority)
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todos[rowToDelete]
                    todoList!.remove(item, from: priority, at: rowToDelete)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    @IBAction func editList(_ sender: Any) {
        shouldEditMenuItemsBeShown = !shouldEditMenuItemsBeShown
        setEditing(!tableView.isEditing, animated: true)
        
        if !self.isEditing {
            navigationItem.title = navigationItemEditableTitleTextField.text
        }
    }
    
//    required init?(coder aDecoder: NSCoder) {
//        todoList = TodoList()
//        super.init(coder: aDecoder)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set large titles
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false

        // Add a bottom toolbar that's transparent with the add button
        navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addToolbarButton.setBackgroundImage(UIImage(named: "circle"), for: .normal, barMetrics: .default)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        // Initializes the button so it doesn't show when not in editing mode
        deleteListItemsButton.image = UIImage()
    }
    
    // Sets the state of editing to prevent other actions while editing
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
        
        // Enhance this to hide / show nav bar buttons
        addToolbarButton.isEnabled = !editing
        deleteListItemsButton.image = UIImage()
        deleteListItemsButton.isEnabled = false
        
        navigationController?.navigationBar.prefersLargeTitles = !editing
        
        if editing && shouldEditMenuItemsBeShown {
            editListButton.image = UIImage(named: "check-white")
            addToolbarButton.setBackgroundImage(UIImage(named: "transparent"), for: .normal, barMetrics: .default)
            addToolbarButton.tintColor = UIColor.clear
            
            deleteListItemsButton.image = UIImage(named: "delete-outline")
            editNavigationItemTitle()
        } else {
            editListButton.image = UIImage(named: "pencil-outline")
            
            addToolbarButton.setBackgroundImage(UIImage(named: "circle"), for: .normal, barMetrics: .default)
            addToolbarButton.tintColor = UIColor.white
            
            navigationItem.titleView = nil
        }
    }
    
    func editNavigationItemTitle() {
        navigationItemEditableTitleTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        navigationItemEditableTitleTextField.text = navigationItem.title
        navigationItemEditableTitleTextField.font = UIFont.systemFont(ofSize: 19)
        navigationItemEditableTitleTextField.textColor = UIColor.white
        navigationItemEditableTitleTextField.textAlignment = .center
        navigationItem.titleView = navigationItemEditableTitleTextField
    }

    // Return the number of rows for a given priority section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todoList!.todoList(for: priority).count
        }
        return 0
    }
    
    // Configure the cells for a given row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItem", for: indexPath)
        if let priority = priorityForSectionIndex(indexPath.section) {
            let items = todoList!.todoList(for: priority)
            let item = items[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows != nil {
            deleteListItemsButton.isEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows == nil {
            deleteListItemsButton.isEnabled = false
        }
    }
    
    // Swipe-right action to complete a todo item
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title:  "Done", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            
            if let cell = tableView.cellForRow(at: indexPath) {
                if let priority = self.priorityForSectionIndex(indexPath.section) {
                    let items = self.todoList!.todoList(for: priority)
                    let item = items[indexPath.row]
                    
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    item.toggleChecked()
                    self.configureCheckmark(for: cell, with: item)
                    
                    // Moves the item to the completed category while preserving it's original priority section
                    if item.checked {
                        self.todoList!.move(item: item, from: priority, at: indexPath.row, to: .completed)
                    } else {
                        self.todoList!.move(item: item, from: priority, at: indexPath.row, to: TodoList.Priority(rawValue: item.priority)!)
                    }
                    
                    self.todoList!.save()
                    self.tableView.reloadData()
                }
            }
            
        })
        doneAction.backgroundColor = UIColor(red: 0.1922, green: 0.549, blue: 0, alpha: 1.0)
        doneAction.image = UIImage(named: "check-white")
        
        shouldEditMenuItemsBeShown = false
        
        return UISwipeActionsConfiguration(actions: [doneAction])
        
    }
    
    // Swipe-left action to delete an item
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .destructive, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if let priority = self.priorityForSectionIndex(indexPath.section) {
                let item = self.todoList!.todoList(for: priority)[indexPath.row]
                self.todoList!.remove(item, from: priority, at: indexPath.row)
                
                self.todoList!.save()
            }

            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)

            success(true)
        })
        modifyAction.backgroundColor = .red
        modifyAction.image = UIImage(named: "delete-outline")
        
        shouldEditMenuItemsBeShown = false

        return UISwipeActionsConfiguration(actions: [modifyAction])
    }
    
    
    // Moves an item when in editing mode and user drags the move bar
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let srcPriority = priorityForSectionIndex(sourceIndexPath.section),
            let destPriority = priorityForSectionIndex(destinationIndexPath.section) {
            let item = todoList!.todoList(for: srcPriority)[sourceIndexPath.row]
            todoList!.move(item: item, from: srcPriority, at: sourceIndexPath.row, to: destPriority, at: destinationIndexPath.row)
        }
        
        todoList!.save()
        tableView.reloadData()
    }
    
    // Configure initial text in a cell
    func configureText(for cell: UITableViewCell, with item: TodoItem) {
        guard let todoCell = cell as? TodoTableViewCell else {
            return
        }
        
        todoCell.todoTextLabel.text = item.title
    }
    
    // Prevents segue from performing if editing is open
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
    }
    
    // Configures the checkmark on initial load & ongoing
    func configureCheckmark(for cell: UITableViewCell, with item: TodoItem) {
        let isChecked = item.checked
        guard let todoCell = cell as? TodoTableViewCell else {
            return
        }

        // Utilize a grayed out image for the checkmark to match the text color
        todoCell.checkmarkImage.isHidden = !isChecked
        let templateImage = todoCell.checkmarkImage.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        todoCell.checkmarkImage.image = templateImage
        todoCell.checkmarkImage.tintColor = .lightGray
        
        // Makes the text lightGray when disabled
        todoCell.todoTextLabel.isEnabled = !isChecked
    }
    
    // Handles Segue's as set up in the Main Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                itemDetailViewController.delegate = self
                itemDetailViewController.todoList = todoList
            }
        } else if segue.identifier == "EditItemSegue" {
            if let itemDetailViewController = segue.destination as? ItemDetailViewController {
                if let cell = sender as? UITableViewCell,
                   let indexPath = tableView.indexPath(for: cell),
                   let priority = priorityForSectionIndex(indexPath.section) {
                    
                    let item = todoList!.todoList(for: priority)[indexPath.row]
                    itemDetailViewController.itemToEdit = item
                    itemDetailViewController.itemIndex = indexPath.row
                    itemDetailViewController.delegate = self
                }
            }
        }
    }
    
    // Return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
    
    // Use the priority as defined in TodoList to set the titles for sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "High Priority"
            case .medium:
                title = "Medium Priority"
            case .low:
                title = "Low Priority"
            case .none:
                title = "No Priority"
            case .completed:
                title = "Completed"
            }
        }
        return title
    }
}

extension TodoViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewControllerDidAdd(_ controller: ItemDetailViewController, didFinishAdding item: TodoItem, for priority: TodoList.Priority) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList!.todoList(for: priority).count - 1
        let indexPath = IndexPath(row: rowIndex, section: priority.rawValue)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        todoList!.save()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: TodoItem) {
            for priority in TodoList.Priority.allCases {
                let currentList = todoList!.todoList(for: priority)
                if let index = currentList.index(of: item) {
                    let indexPath = IndexPath(row: index, section: priority.rawValue)
                    if let cell = tableView.cellForRow(at: indexPath) {
                        configureText(for: cell, with: item)
                    }
                    
                    if priority.rawValue != item.priority {
                        todoList!.move(item: item, from: priority, at: index, to: TodoList.Priority(rawValue: item.priority)!)
                    }
                }
            }
        
        todoList!.save()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

