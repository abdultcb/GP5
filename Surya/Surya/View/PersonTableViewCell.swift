//
//  PersonTableViewCell.swift
//  Surya
//
//  Created by Abdul Yasin on 20/02/19.
//  Copyright © 2019 Abdul Yasin. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    static let id = "PersonTableViewCell"
    
    @IBOutlet weak var emailIDLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
