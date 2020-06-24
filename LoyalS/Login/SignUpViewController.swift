import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        retypePasswordTextField.delegate = self
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 10
            signUpButton.layer.borderWidth = 1
            signUpButton.layer.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Actions

    @IBAction func returnToPreviousVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            retypePasswordTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    // MARK: - Sign up
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var errorMessage = "Invalid segue identifier."
        
        if identifier == "userSignUp" {
            if passwordTextField.text != retypePasswordTextField.text {
                errorMessage = "Passwords do not match. Please re-type your password."
            }
            else if passwordTextField.text!.isEmpty || retypePasswordTextField.text!.isEmpty || emailTextField.text!.isEmpty {
                errorMessage = "Fields cannot be empty. Please type needed information into all fields."
            }
            else if !Utilities.isValidEmail(emailTextField.text!) {
                errorMessage = "Invalid e-mail. Please enter your valid e-mail."
            }
            else if !Utilities.isValidPassword(passwordTextField.text!) {
                errorMessage = "Invalid password. Please enter your valid password."
            }
                // valid input, signing up user
            else {
                var errorOccured = false
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error == nil {
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if error == nil {
                                // registering user at out backend
                                APIManager.shared.register(idToken: idToken!) {
                                
                                }
                                // setting user info in out app
                                APIManager.shared.getUserInfo(idToken: idToken!) { (json) in
                                    User.currentUser.setInfo(json: json, authtoken: idToken!)
                                    
                                }
                        
                                if let pictureURL = currentUser?.photoURL {
                                    User.currentUser.pictureURL = pictureURL.path
                                }

                            } else {
                                errorOccured = true
                                errorMessage = "Account could not be created, please try again."
                            }
                            
                        }
                        
                    } else {
                        errorOccured = true
                        errorMessage = "Invalid data. Account could not be created, please enter valid data."
                    }
                    
                }
                if !errorOccured {
                    return true
                }
            }
            
        }
        let alertController = UIAlertController(title: "Error occured", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
 
        return false
    }
    
}
