//
//  PlayerViewCell.swift
//  RustRcon
//
//  Created by Louis Gornall on 30/09/2017.
//  Copyright © 2017 Louis Gornall. All rights reserved.
//

import UIKit

class PlayerViewCell: UITableViewCell {

    @IBOutlet weak var playnameLabel: UILabel!
    
    @IBOutlet weak var playerConnected: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
