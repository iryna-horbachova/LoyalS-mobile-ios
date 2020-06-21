import UIKit
import Firebase

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
    
    @IBAction func resetPassword(_ sender: UIButton) {
        var errorMessage = "Error occured"
        if emailTextField.text!.isEmpty {
            errorMessage = "E-mail field can't be empty!"
        } else if !Utilities.isValidEmail(emailTextField.text!) {
            errorMessage = "Invalid e-mail!"
        } else {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
                if error == nil {
                    let alertController = UIAlertController(title: "Password was reset", message: errorMessage , preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    errorMessage = "Unexpected error. Check the details and try again"
                }
            }
        }
        let alertController = UIAlertController(title: "Password can't be reset", message: errorMessage , preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)

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
