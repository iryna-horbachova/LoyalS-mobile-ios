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

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 10
            signUpButton.layer.borderWidth = 1
            signUpButton.layer.borderColor = #colorLiteral(red: 0.3208748645, green: 0.5747793331, blue: 1, alpha: 1)
        }
    }
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.tintColor = #colorLiteral(red: 0.3208748645, green: 0.5747793331, blue: 1, alpha: 1)
        }
    }

    @IBAction func returnToPreviousVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    // MARK: - Sign up
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "userSignUp" {
            if passwordTextField.text != retypePasswordTextField.text {
                let alertController = UIAlertController(title: "Passwords do not match", message: "Please re-type your password", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                DispatchQueue.main.async{
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            else if passwordTextField.text!.isEmpty || retypePasswordTextField.text!.isEmpty || emailTextField.text!.isEmpty {
                let alertController = UIAlertController(title: "Fields cannot be empty", message: "Please type needed information into all fields", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                DispatchQueue.main.async{
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            else if !Utilities.isValidEmail(emailTextField.text!) {
                let alertController = UIAlertController(title: "Invalid e-mail", message: "Please enter your valid e-mail", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                DispatchQueue.main.async{
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else if !Utilities.isValidPassword(passwordTextField.text!) {
                let alertController = UIAlertController(title: "Invalid password", message: "Your password must be at lest 8 characters", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                DispatchQueue.main.async{
                    self.present(alertController, animated: true, completion: nil)
                }
            }
                // valid input, signing up user
            else {
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    if error == nil {
                        let currentUser = Auth.auth().currentUser
                        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                            if error == nil {
                                APIManager.shared.register(idToken: idToken!) {
                                
                                }
                                
                              //  User.currentUser.authtoken = idToken
                              //  User.currentUser.email = currentUser?.email
                                
                                if let pictureURL = currentUser?.photoURL {
                                    User.currentUser.pictureURL = pictureURL.path
                                   
                                }
                            
                                APIManager.shared.getUserInfo(idToken: idToken!) { (json) in
                                    
                                    User.currentUser.setInfo(json: json, authtoken: idToken!)
                                    
                                }
                            }
                            
                        }
                        
                    } else {
                        let alertController = UIAlertController(title: "Invalid data", message: "Account could not be created, please enter valid data", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okAction)
                        
                        DispatchQueue.main.async{
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                }
                return true
                
            }
            
        }
        return false
    }
    
}
