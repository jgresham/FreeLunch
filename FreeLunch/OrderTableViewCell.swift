//
//  OrderTableViewCell.swift
//  FreeLunch
//
//  Created by Johns Gresham on 11/26/17.
//  Copyright © 2017 Johns Gresham. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderDescription: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
