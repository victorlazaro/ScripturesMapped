//
//  ScriptureTableViewCell.swift
//  ScripturesMapped
//
//  Created by Victor Lazaro on 10/30/17.
//  Copyright © 2017 Victor Lazaro. All rights reserved.
//

import UIKit

class ScriptureTableViewCell: UITableViewCell {

    
    @IBOutlet weak var scriptureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
