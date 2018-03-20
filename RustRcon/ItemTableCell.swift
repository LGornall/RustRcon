//
//  ItemTableCell.swift
//  RustRcon
//
//  Created by Louis Gornall on 04/10/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit

class ItemTableCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
