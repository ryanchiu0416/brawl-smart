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
    @IBOutlet weak var myStatsButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    var defaults: UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerService = PlayerDataService()
        self.defaults = UserDefaults.standard
        self.searchButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.6)
        self.searchButton.layer.cornerRadius = 8
        self.myStatsButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        self.myStatsButton.layer.cornerRadius = 8
        
        // to move up view when keyboard is toggled
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        // to cancel keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // to move up view when keyboard is toggled
    // refer to solution: https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    // to move up view when keyboard is toggled
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // cancel keyboard when user clicks on somewhere on the screen
    // https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if self.defaults.object(forKey: "myPlayerTag") != nil {
            myStatsButton.isEnabled = true
            self.myStatsButton.backgroundColor = self.myStatsButton.backgroundColor?.withAlphaComponent(0.8)
        } else {
            myStatsButton.isEnabled = false
            self.myStatsButton.backgroundColor = self.myStatsButton.backgroundColor?.withAlphaComponent(0.2)
        }
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
    
    
    @IBAction func searchMyStatsButtonClick(_ sender: Any) {
        self.idTextField.text = self.defaults.value(forKey: "myPlayerTag") as? String
        searchButtonClick(self)
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


