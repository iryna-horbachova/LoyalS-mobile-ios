import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 10
            signInButton.layer.borderWidth = 1
            signInButton.layer.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        }
    }
    
    @IBAction func returnToPrevousVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       textField.placeholder = nil
    }
    
    
    // MARK: - Authentication
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var errorMessage = "Invalid segue identifier"
        if identifier == "userSignIn" {
            if passwordTextField.text!.isEmpty || emailTextField.text!.isEmpty {
                errorMessage = "Fields can't be empty!"
            }
            else if !Utilities.isValidEmail(emailTextField.text!) {
                errorMessage = "Please enter your valid e-mail"
            }
            else if !Utilities.isValidPassword(emailTextField.text!) {
                errorMessage = "Your password must be at lest 8 characters"
            }
            else {
                var errorOccured = false
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error == nil {

                        let currentUser = Auth.auth().currentUser
                        
                        User.currentUser.email = currentUser?.email
                        
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if error == nil {
                                User.currentUser.authtoken = idToken

                                if let pictureURL = currentUser?.photoURL {
                                    User.currentUser.pictureURL = pictureURL.path
                                }
                                
                                     APIManager.shared.getUserInfo(idToken: idToken!) { (json) in
                                 User.currentUser.setInfo(json: json, authtoken: idToken!)
                                      }
                            } else {
                                errorOccured = true
                                errorMessage = "Authentication Error"
                            }
                        }
                        
                    } else {
                        errorOccured = true
                        errorMessage = "Invalid e-mail or password"
                    }
                }
                
                if !errorOccured {
                    return true
                }
            }
        } else if identifier == "resetPassword" {
            return true
        }
        
        let alertController = UIAlertController(title: "Error occured", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)

        return false
        
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITextFieldDelegation
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
}
