//
//  TodoTableViewCell.swift
//  todo
//
//  Created by Andrew Johnston on 12/4/18.
//  Copyright © 2018 Andrew Johnston. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var todoTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
