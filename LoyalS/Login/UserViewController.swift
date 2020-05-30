//
//  UserViewController.swift
//  LoyalS
//

import UIKit
import Firebase

class UserViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var coinsSpentLabel: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPage()
    }
    
    // MARK: - Page setup
    
    func setUpPage() {
        print("setting up page")
        if Auth.auth().currentUser != nil {
            if User.currentUser.authtoken == nil {
                print("authtoken is nil")
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if error == nil {
                        print(idToken)
                        APIManager.shared.getUserInfo(idToken: idToken!) { (json) in
                            print("getting user info")
                            User.currentUser.setInfo(json: json, authtoken: idToken!)
                            print(User.currentUser.authtoken)
                            }
                    }
                }
            }
            nameLabel.text = User.currentUser.name
            currentBalanceLabel.text = String(User.currentUser.currentBalance!)
            coinsSpentLabel.text = String(User.currentUser.coinsSpent!)
        }
    }
    
    // MARK: - Sign out
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            User.currentUser.resetInfo()
            self.performSegue(withIdentifier: "userSignOut", sender: self)
        } catch {
            print("Sign out error")
        }
    }

}
