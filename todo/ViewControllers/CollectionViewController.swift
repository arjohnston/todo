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

    var lists: [[TodoItem]]
    
    required init?(coder aDecoder: NSCoder) {
        lists = FileManager().loadLists()
        super.init(coder: aDecoder)
    }
    
    @IBAction func addCollectionButton(_ sender: Any) {
        let newList: [TodoItem] = []
        lists.append(newList)
        
        let indexPath = IndexPath(row: lists.count - 1, section: 0)
        collectionView.insertItems(at: [indexPath])
        
        FileManager().saveLists(lists: lists)
        
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
        
//        self.navigationController?.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // Handles Segue's as set up in the Main Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectListSegue" {
            if let todoViewController = segue.destination as? TodoViewController {
                if let cell = sender as? UICollectionViewCell,
                   let indexPath = collectionView.indexPath(for: cell) {
                    // Reload the list for any newly savedr information
                    lists = FileManager().loadLists()
                    
                    todoViewController.lists = lists
                    todoViewController.selectedList = lists[indexPath.row]
                    todoViewController.indexOfList = indexPath.row
                    todoViewController.tableView.reloadData()
                }
            }
        }
    }
    
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        if let label = cell as? CollectionViewCell {
            label.collectionViewCellTitle.text = "hi"
        }

        return cell
    }
}
