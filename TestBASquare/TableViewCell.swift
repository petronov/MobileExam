//
//  TableViewCell.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var cityName: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        //debugPrint("city: \(cityName)")
        // Configure the view for the selected state
    }
}
