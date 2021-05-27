//
//  CharacterListViewController.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/12/21.
//

import UIKit

class BrawlerListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var brawlerService: BrawlerDataService!
    var brawlerList: [Brawler] = []
    var isEmptyList: Bool!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        let statusBar1 =  UIView()
//        statusBar1.frame = UIApplication.shared.statusBarFrame
//        statusBar1.backgroundColor = hexStringToUIColor(hex: "FFD039")
//        UIApplication.shared.keyWindow?.addSubview(statusBar1)
        addStatusBarColor()
        
        
        
        // Do any additional setup after loading the view.
        self.activityIndicatorView.startAnimating()
        self.brawlerService = BrawlerDataService()
        self.isEmptyList = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let confirmedService = self.brawlerService else { return }
        
        confirmedService.fetchBrawlersData(completion: {characters, error in
            guard let characters = characters, error == nil else {
                if error.unsafelyUnwrapped as! BrawlerDataCallingError == BrawlerDataCallingError.errorGeneratingURL
                    || error.unsafelyUnwrapped as! BrawlerDataCallingError == BrawlerDataCallingError.errorGettingDataFromAPI {
                    self.showErrorAlert()
                } else {
                    self.isEmptyList = true
                    self.tableView.reloadData()
                }
                self.activityIndicatorView.stopAnimating()
                return
            }
            
            self.brawlerList = characters
            self.isEmptyList = false
            self.tableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Connection Error", message: "Unable to fetch instances", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            // Do nothing
        }))
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: {_ in
            // Retry
            self.viewDidLoad()
            self.viewWillAppear(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? BrawlerDetailViewController,
            let selectedIndexPath = self.tableView.indexPathForSelectedRow,
            let cell = self.tableView.cellForRow(at: selectedIndexPath) as? BrawlerCell
        else { return }
        
        destination.brawler = cell.brawler
    }


}

extension BrawlerListViewController: UITableViewDataSource {
    // MARK: Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isEmptyList {
            return 1
        }
        return self.brawlerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isEmptyList {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "emptyCell")
            cell?.textLabel?.text = "Empty brawler list"
            cell?.textLabel?.textAlignment = .center
            return cell!
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BrawlerCell")
            as! BrawlerCell
        let currBrawler = self.brawlerList[indexPath.row]
        cell.brawler = currBrawler
        return cell
    }
}

extension BrawlerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var text = "Favorite"
        var actionImg = UIImage(systemName: "heart")
        if self.brawlerList[indexPath.row].isFavorite {
            text = "Unfavorite"
            actionImg = UIImage(systemName: "heart.fill")
        }
        
        
        let action = UIContextualAction(style: .normal, title: text, handler: {(action, view, completion) in
            if let cell = self.tableView.cellForRow(at: indexPath) as? BrawlerCell,
               let confirmedCharacter = cell.brawler {
                confirmedCharacter.isFavorite = !confirmedCharacter.isFavorite
                let customAccessoryView = UIImageView(image: UIImage(named: "logo"))
                customAccessoryView.tintColor = UIColor.red
                cell.accessoryView = confirmedCharacter.isFavorite ? customAccessoryView : .none
                completion(true)
            }
        })
        
        action.image = actionImg
        action.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// from stackoverflow: https://stackoverflow.com/questions/24263007/how-to-use-hex-color-values/24263296
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

// from stackoverflow: https://stackoverflow.com/questions/56651245/how-to-change-the-status-bar-background-color-and-text-color-on-ios-13
func addStatusBarColor() {
    let statusBar1 =  UIView()
    statusBar1.frame = UIApplication.shared.statusBarFrame
    statusBar1.backgroundColor = hexStringToUIColor(hex: "FFD039")
    UIApplication.shared.keyWindow?.addSubview(statusBar1)
}
