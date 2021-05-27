//
//  PlayerSearchViewController.swift
//  BrawlSmart
//
//  Created by Ryan Chiu on 5/12/21.
//

import UIKit

class PlayerSearchViewController: UIViewController {
    var playerService: PlayerDataService!
    var player: Player!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerService = PlayerDataService()
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? PlayerDetailViewController
        else { return }
        
        destination.player = self.player
    }
    

    @IBAction func searchButtonClick(_ sender: Any) {
        self.activityIndicatorView.startAnimating()
        self.searchButton.isEnabled = false

        guard let confirmedService = self.playerService else { return }
        confirmedService.fetchPlayersData(tag: idTextField.text!, completion: {player, error in
            guard let player = player, error == nil else {
                if error.unsafelyUnwrapped as! PlayerDataCallingError == PlayerDataCallingError.errorGeneratingURL
                    || error.unsafelyUnwrapped as! PlayerDataCallingError == PlayerDataCallingError.errorGettingDataFromAPI {
                    self.showConnectionErrorAlert()
                } else { // user not found
                    self.showUserNotFoundErrorAlert()
                }
                self.searchButton.isEnabled = true
                self.idTextField.text = ""
                self.activityIndicatorView.stopAnimating()
                return
            }
            
            self.player = player
            self.performSegue(withIdentifier: "goToDetailSegue", sender: self)
            self.idTextField.text = ""
            self.searchButton.isEnabled = true
            self.activityIndicatorView.stopAnimating()
        })
    }
    
    func showConnectionErrorAlert() {
        let alert = UIAlertController(title: "Connection Error", message: "Unable to fetch instances", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            // Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUserNotFoundErrorAlert() {
        let alert = UIAlertController(title: "User Not Found Error", message: "Unable to find user", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            // Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
