import UIKit
import Firebase

class UserViewController: UIViewController {
    
    // MARK: - Variables
     let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var coinsSpentLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
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
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if error == nil {
                        APIManager.shared.getUserInfo(idToken: idToken!) { (json) in
                            User.currentUser.setInfo(json: json, authtoken: idToken!)
                        }
                    }
                }
            }
            // showing activity indicator
            Utilities.showActivityIndicator(activityIndicator, view)
            
            // setting labels
            
            nameLabel.text = User.currentUser.name
            
            if let currentBalance = User.currentUser.currentBalance {
                currentBalanceLabel.text = String(currentBalance)
            }
            
            if let coinsSpent = User.currentUser.coinsSpent {
                coinsSpentLabel.text = String(coinsSpent)
            }
            
            // setting user's image
            
            if let relativeUserAvatarURL = User.currentUser.pictureURL {
                let fullUserAvatarImageURL = NSURL(string: BASE_URL)?.appendingPathComponent(relativeUserAvatarURL)
                
                Utilities.loadImage(imageView: userAvatarImageView
                    , imageURL: fullUserAvatarImageURL!)
            }
            
            // hiding activity indicator after everything is set
            
            Utilities.hideActivityIndicator(activityIndicator)

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
