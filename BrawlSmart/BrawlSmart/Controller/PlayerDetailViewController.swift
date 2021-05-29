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
    var defaults: UserDefaults!
    @IBOutlet weak var markButton: UIBarButtonItem!
    var isMarked = false
    
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
        self.defaults = UserDefaults.standard
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.defaults.object(forKey: "myPlayerTag") != nil && self.defaults.value(forKey: "myPlayerTag") as! String == self.player.tag.dropFirst(1) {
            self.markButton.image = UIImage(systemName: "person.fill.xmark")
            self.isMarked = true
        } else {
            self.markButton.image = UIImage(systemName: "person.fill.checkmark")
            self.isMarked = false
        }
    }
    
    
    
    @IBAction func markAsMyStatsButtonClick(_ sender: Any) {
        if self.isMarked {
            self.defaults.removeObject(forKey: "myPlayerTag")
            showToastMessage(msg: "Unsaved as My Stats", color: UIColor.systemRed)
            self.markButton.image = UIImage(systemName: "person.fill.checkmark")
        } else {
            self.defaults.set(self.player.tag.dropFirst(1), forKey: "myPlayerTag")
            showToastMessage(msg: "Saved as My Stats", color: UIColor.systemGreen)
            self.markButton.image = UIImage(systemName: "person.fill.xmark")
        }
        self.isMarked = !self.isMarked
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // refer to: https://www.youtube.com/watch?v=0M9g_w6MSiM
    func showToastMessage(msg: String, color: UIColor) {
        let label = UILabel(frame: CGRect(x: self.view.frame.width/2-100, y: self.view.frame.height-150, width: 200, height: 40))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = color.withAlphaComponent(0.7)
        label.alpha = 1.0
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.text = msg
        self.view.addSubview(label)
        
        UIView.animate(withDuration: 2.5, delay: 1.0, options: .curveEaseInOut, animations: {
            label.alpha = 0.0
        }) { (isCompleted) in
            label.removeFromSuperview()
        }
    }
    
    
}

