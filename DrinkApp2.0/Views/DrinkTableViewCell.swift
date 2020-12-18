//
//  DrinkTableViewCell.swift
//  DrinkApp2.0
//
//  Created by 林祐辰 on 2020/12/15.
//

import UIKit

class DrinkTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var drinkDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
