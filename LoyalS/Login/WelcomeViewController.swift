//
//  WelcomeViewController.swift
//  LoyalS
//


import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 10
            signUpButton.layer.borderWidth = 1
            signUpButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 10
            signInButton.layer.borderWidth = 1
            signInButton.layer.borderColor = #colorLiteral(red: 0.5173531467, green: 0.7064570221, blue: 1, alpha: 1)
        }
    }
    
    // MARK: Lifecycle methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

}
