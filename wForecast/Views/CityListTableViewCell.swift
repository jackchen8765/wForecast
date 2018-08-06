//
//  CityListTableViewCell.swift
//  wForecast
//
//  Created by Liangzan Chen on 12/16/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit

class CityListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
