//
//  bannedPlayerCell.swift
//  RustRcon
//
//  Created by Louis Gornall on 24/10/2017.
//  Copyright © 2017 ShantyShackApps. All rights reserved.
//

import UIKit

class bannedPlayerCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var banReason: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
