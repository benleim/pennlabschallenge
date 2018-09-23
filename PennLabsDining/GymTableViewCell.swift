//
//  DiningHallTableViewCell.swift
//  PennLabsDining
//
//  Created by William Leimberger on 9/22/18.
//  Copyright © 2018 William Leimberger. All rights reserved.
//

import UIKit

class GymTableViewCell: UITableViewCell {

    @IBOutlet weak var HallImage: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var TimesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
