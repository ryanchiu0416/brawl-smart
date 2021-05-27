//
//  BrawlerCell.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/12/21.
//

import UIKit

class BrawlerCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var brawlerImageView: UIImageView!
    
    var brawler: Brawler? {
        didSet {
            self.nameLabel.text = brawler?.name
            self.classLabel.text = brawler?.class.name
            self.rarityLabel.text = brawler?.rarity.name
            self.rarityLabel.textColor = hexStringToUIColor(hex: (brawler?.rarity.color)!)
            self.descriptionLabel.text = brawler?.description
            
            let customAccessoryView = UIImageView(image: UIImage(named: "league_icon"))
            customAccessoryView.tintColor = UIColor.red
            self.accessoryView = self.brawler!.isFavorite ? customAccessoryView : .none
            
            if self.brawler!.imageData == nil {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.brawler?.imageData = NSData(contentsOf: URL(string: self.brawler!.imageUrl)!)
                    DispatchQueue.main.async {
                        if self.brawler?.imageData == nil {return}
                        self.brawlerImageView.image = UIImage(data: self.brawler!.imageData! as Data)
                        self.brawlerImageView.layer.cornerRadius = self.brawlerImageView.frame.width / 2
                    }
                }
            } else {
                self.brawlerImageView.image = UIImage(data: self.brawler!.imageData! as Data)
                self.brawlerImageView.layer.cornerRadius = self.brawlerImageView.frame.width / 2
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
