//
//  PlayerDetailViewController.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/21/21.
//

import UIKit

class PlayerDetailViewController: UIViewController {
    var player: Player!
    @IBOutlet weak var playerIconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vict3v3Label: UILabel!
    @IBOutlet weak var victSoloLabel: UILabel!
    @IBOutlet weak var victDuoLabel: UILabel!
    @IBOutlet weak var trophyLabel: UILabel!
    @IBOutlet weak var highestTrophyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = self.player.tag
        DispatchQueue.global(qos: .userInitiated).async {
            let imgData = NSData(contentsOf: URL(string: "https://cdn.brawlify.com/profile/\(self.player!.icon!.id).png?v=1")!)
            DispatchQueue.main.async {
                if imgData == nil {return}
                self.playerIconImage.image = UIImage(data: imgData! as Data)
            }
        }
        self.nameLabel.text = self.player.name
        let colorStr = String(self.player.nameColor.dropFirst(4))
        self.nameLabel.textColor = hexStringToUIColor(hex: colorStr)
        self.trophyLabel.text = String(self.player.trophies)
        self.vict3v3Label.text = String(self.player._3vs3Victories)
        self.victDuoLabel.text = String(self.player.duoVictories)
        self.victSoloLabel.text = String(self.player.soloVictories)
        self.highestTrophyLabel.text = String(self.player.highestTrophies)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
