//
//  CollectionViewController.swift
//  todo
//
//  Created by Andrew Johnston on 12/10/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addCollectionViewCell: UIBarButtonItem!

    var todoList: TodoList
    
    var collectionData = [
        "1", "2", "3", "4"
    ]
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }
    
    @IBAction func addCollectionButton(_ sender: Any) {
        collectionData.append("\(collectionData.count + 1)")
        
        let indexPath = IndexPath(row: collectionData.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Size the collection view cell
        var width = view.frame.size.width / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        width = width - layout.minimumInteritemSpacing / 2
        layout.itemSize = CGSize(width: width, height: width)
        
        // Style the back button on the next scene to have a collection picture
        var backBtn = UIImage(named: "collection")
        backBtn = backBtn?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.navigationController!.navigationBar.backIndicatorImage = backBtn
        self.navigationController!.navigationBar.backIndicatorTransitionMaskImage = backBtn
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Setup the toolbar on bottom w/ an add button
        navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        self.navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addCollectionViewCell.setBackgroundImage(UIImage(named: "circle"), for: .normal, barMetrics: .default)

    }
    
    // Handles Segue's as set up in the Main Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectListSegue" {

            if let todoViewController = segue.destination as? TodoViewController {
                todoViewController.todoList = todoList
                
//                if let cell = sender as? UICollectionViewCell,
//                   let indexPath = collectionView.indexPath(for: cell) {
                
                    let list = todoList // this should select the one... using [indexPath.row]
                    todoViewController.todoList = list
//                }
            }
        }
    }
    
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        if let label = cell as? CollectionViewCell {
            label.collectionViewCellTitle.text = collectionData[indexPath.row]
        }

        return cell
    }
}
