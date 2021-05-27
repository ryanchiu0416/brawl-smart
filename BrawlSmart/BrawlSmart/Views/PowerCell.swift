//
//  StarPowerTableViewCell.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/20/21.
//

import UIKit

class PowerCell: UITableViewCell {
    
    @IBOutlet weak var backgroundIconImg: UIImageView!
    @IBOutlet weak var powerIconImg: UIImageView!
    @IBOutlet weak var powerNameLabel: UILabel!
    @IBOutlet weak var powerDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
