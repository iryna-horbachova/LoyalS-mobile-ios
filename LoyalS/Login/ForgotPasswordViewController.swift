//
//  ForgotPasswordViewController.swift
//  LoyalS
//


import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    //  MARK: - Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton! {
        didSet {
            resetPasswordButton.layer.cornerRadius = 10
            resetPasswordButton.layer.borderWidth = 1
            resetPasswordButton.layer.borderColor = #colorLiteral(red: 0.3208748645, green: 0.5747793331, blue: 1, alpha: 1)
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.tintColor = #colorLiteral(red: 0.3208748645, green: 0.5747793331, blue: 1, alpha: 1)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func returnToPreviousVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // UITextFieldDelegate
        
        emailTextField.delegate = self
        
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
