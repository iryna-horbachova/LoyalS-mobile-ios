import UIKit
import Firebase

// Controller of user's profile

class UserViewController: UIViewController,  UITableViewDelegate,  UITableViewDataSource {
    
    // MARK: - Variables
    
    var usedDiscounts = [Discount]()
    let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var coinsSpentLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setUpPage()
        loadDiscountsHistory()
    }
    
    // MARK: Managing TableView with history of discounts
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedDiscounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDiscountCell", for: indexPath)
        if let cell = cell as? UsedDiscountTableViewCell {
            let discount = usedDiscounts[indexPath.row]
            
            cell.discountTitle.text = discount.title
            // cell.categoryTitleLabel.text = discount.category
            
            cell.priceButton.setTitle(String(discount.price!), for: .normal)
            
            if let relativeDiscountPictureURL = discount.pictureURL {
                let fullDiscountPictureURL = NSURL(string: BASE_URL)?.appendingPathComponent(relativeDiscountPictureURL)
                
                Utilities.loadImage(imageView: cell.discountImageView
                    , imageURL: fullDiscountPictureURL!)
                
            }
        }
        
        
        return cell
    }
    
    // MARK: - loading history of discounts
    
    func loadDiscountsHistory() {
        Utilities.showActivityIndicator(activityIndicator, view)
        APIManager.shared.getAvailableDiscounts(userId: User.currentUser.id!, city: User.currentUser.currentLocation ?? User.defaultLocation) { (json) in
            if json != nil {
                self.usedDiscounts = []
                
                if let listDiscounts = json!.array {
                    for item in listDiscounts {
                        let discount = Discount(json: item)
                        self.usedDiscounts.append(discount)
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
     // MARK: - Profile setup
    
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
