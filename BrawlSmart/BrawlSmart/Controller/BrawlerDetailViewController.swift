//
//  BrawlerDetailViewController.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/19/21.
//

import UIKit

class BrawlerDetailViewController: UIViewController {
    @IBOutlet weak var brawlerImageView: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var powerTableView: UITableView!
    var brawler: Brawler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.brawler.name
        if self.brawler!.imageData == nil {
            DispatchQueue.global(qos: .userInitiated).async {
                self.brawler?.imageData = NSData(contentsOf: URL(string: self.brawler!.imageUrl)!)
                DispatchQueue.main.async {
                    if self.brawler?.imageData == nil {return}
                    self.brawlerImageView.image = UIImage(data: self.brawler!.imageData! as Data)
                    self.brawlerImageView.layer.cornerRadius = self.brawlerImageView.frame.width / 2.3
                }
            }
        } else {
            self.brawlerImageView.image = UIImage(data: self.brawler!.imageData! as Data)
            self.brawlerImageView.layer.cornerRadius = self.brawlerImageView.frame.width / 2.3
        }
        
        self.classLabel.text = self.brawler.class.name
        self.rarityLabel.text = self.brawler.rarity.name
        self.rarityLabel.textColor = hexStringToUIColor(hex: (brawler?.rarity.color)!)
        self.descriptionLabel.text = self.brawler.description
        
        self.powerTableView.heightAnchor.constraint(equalTo: self.powerTableView.heightAnchor, multiplier: 1, constant: 500).isActive = true
        
        let rowHeight = 120
        let tableViewHeight = rowHeight * (self.brawler.starPowers.count + self.brawler.gadgets.count)
        
        NSLayoutConstraint(item: self.powerTableView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: CGFloat(tableViewHeight)).isActive = true

        self.powerTableView.delegate = self
        self.powerTableView.dataSource = self
        
    }
    

}

extension BrawlerDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brawler.starPowers.count + self.brawler.gadgets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.powerTableView.dequeueReusableCell(withIdentifier: "powerCell")
            as! PowerCell
        var imgUrl: String = ""
        if indexPath.row >= self.brawler.starPowers.count {
            cell.backgroundIconImg.image = UIImage(named: "icon_gadget")
            let idx = indexPath.row-self.brawler.starPowers.count
            imgUrl = self.brawler!.gadgets[idx].imageUrl
            cell.powerNameLabel.text = self.brawler.gadgets[idx].name
            cell.powerDescriptionLabel.text = self.brawler.gadgets[idx].description
                                                .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        } else {
            cell.backgroundIconImg.image = UIImage(named: "icon_star_power")
            imgUrl = self.brawler!.starPowers[indexPath.row].imageUrl
            cell.powerNameLabel.text = self.brawler.starPowers[indexPath.row].name
            cell.powerDescriptionLabel.text = self.brawler.starPowers[indexPath.row].description
                                                .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let powerImg = NSData(contentsOf: URL(string: imgUrl)!)
            DispatchQueue.main.async {
                if powerImg == nil {return}
                cell.powerIconImg.image = UIImage(data: powerImg! as Data)
            }
        }
        
//        var string = "<!DOCTYPE html> <html> <body> <h1>My First Heading</h1> <p>My first paragraph.</p> </body> </html>"
//        let str = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        
        return cell
    }
    


}

extension BrawlerDetailViewController: UITableViewDelegate {

}
