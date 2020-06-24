import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.tintColor = #colorLiteral(red: 0.3208748645, green: 0.5747793331, blue: 1, alpha: 1)
        }
    }
    
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.layer.cornerRadius = 10
            signInButton.layer.borderWidth = 1
            signInButton.layer.borderColor = #colorLiteral(red: 0.3208748645, green: 0.5747793331, blue: 1, alpha: 1)
        }
    }
    @IBOutlet weak var signInFacebookButton: UIButton! {
        didSet {
            signInFacebookButton.layer.cornerRadius = 10
            signInFacebookButton.layer.borderWidth = 1
            signInFacebookButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let fbIcon = UIImage(named: "icon-facebook")?.withRenderingMode(.alwaysTemplate)
            signInFacebookButton.setImage(fbIcon, for: .normal)
            signInFacebookButton.imageView?.contentMode = .scaleAspectFill
            signInFacebookButton.tintColor = .white
        }
    }
    @IBOutlet weak var signInGoogleButton: UIButton! {
        didSet {
            signInGoogleButton.layer.cornerRadius = 10
            signInGoogleButton.layer.borderWidth = 1
            
            let googleIcon = UIImage(named: "icon-google")?.withRenderingMode(.alwaysTemplate)
            signInGoogleButton.setImage(googleIcon, for: .normal)
            signInGoogleButton.imageView?.contentMode = .scaleAspectFill
            signInGoogleButton.tintColor = .white
           // signInGoogleButton.imageEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 20)
        }
    }
    
    @IBAction func returnToPrevousVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    // MARK: - Authentication
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var shouldSegue = false
        
        if identifier == "userSignIn" {
            if passwordTextField.text!.isEmpty || emailTextField.text!.isEmpty {
                let alertController = UIAlertController(title: "Fields cannot be empty", message: "Please type needed information into all fields", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else if !Utilities.isValidEmail(emailTextField.text!) {
                let alertController = UIAlertController(title: "Invalid e-mail", message: "Please enter your valid e-mail", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else if !Utilities.isValidPassword(emailTextField.text!) {
                let alertController = UIAlertController(title: "Invalid password", message: "Your password must be at lest 8 characters", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                print("sign in")
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error == nil {
                        print("error is nil in sign in")
                        let currentUser = Auth.auth().currentUser
                        
                        User.currentUser.email = currentUser?.email
                        
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if error == nil {
                                //User.currentUser.authtoken = idToken
                                
                                print("setting email")
                                print(User.currentUser.email)
                                print("photourl")
                                if let pictureURL = currentUser?.photoURL {
                                    print("path exists")
                                    User.currentUser.pictureURL = pictureURL.path
                                    print(User.currentUser.pictureURL)
                                }
                                
                                //     APIManager.shared.getUserInfo(idToken: idToken!) { (json) in
                                // User.currentUser.setInfo(json: json, authtoken: idToken!)
                                //      }
                            } else {
                                
                            }
                        }
                        shouldSegue = true
                    } else {
                        let alertController = UIAlertController(title: "Error!", message: "Invalid e-mail or password", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                }
            }
        }
        print("SHOULD SEGUE")
        print(shouldSegue)
        return shouldSegue
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITextFieldDelegation
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
}
