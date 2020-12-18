//
//  DrinkCell.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/16.
//

import UIKit

class DrinkCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var drink: UILabel!
    @IBOutlet weak var sugar: UILabel!
    @IBOutlet weak var ice: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var dollar: UILabel!
    @IBOutlet weak var drinkimage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
