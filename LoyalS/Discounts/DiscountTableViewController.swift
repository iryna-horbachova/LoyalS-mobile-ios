import UIKit

class DiscountTableViewController: BaseViewController {
    
    // MARK: - Variables
    
    var discounts = [Discount]()
    
    let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDiscounts()
        
    }
    
    // MARK: - Methods
    
    func loadDiscounts() {
        Utilities.showActivityIndicator(activityIndicator, view)
        APIManager.shared.getAvailableDiscounts(userId: User.currentUser.id!, city: User.currentUser.currentLocation ?? User.defaultLocation) { (json) in
            if json != nil {
                self.discounts = []
                
                if let listDiscounts = json!.array {
                    for item in listDiscounts {
                        let discount = Discount(json: item)
                        self.discounts.append(discount)
                    }
            
                    self.tableView.reloadData()
                }
            } else {
                let alertController = UIAlertController(title: "No discounts", message: "Unfortunately no discounts were found based on your preferences" , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return discounts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "discountCell", for: indexPath)
        if let cell = cell as? DiscountTableViewCell {
            let discount = discounts[indexPath.row]
            cell.discountTitleLabel.text = discount.title
            cell.categoryTitleLabel.text = discount.category
                
            // formatting the date
                
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let dateString = dateFormatter.string(from: discount.startDate!) + "-" + dateFormatter.string(from: discount.endDate!)
            cell.startEndDateLabel.text = dateString
            
            // loading discount picture
            if let relativeDiscountPictureURL = discount.pictureURL {
                let fullDiscountPictureURL = NSURL(string: BASE_URL)?.appendingPathComponent(relativeDiscountPictureURL)
                
                Utilities.loadImage(imageView: cell.discountImageView
                    , imageURL: fullDiscountPictureURL!)
                
            }
        }

        return cell
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var errorMessage = "Invalid segue identifier :("
        if identifier == "buyDiscount" {
            guard let senderDiscountCell = sender as? DiscountTableViewCell else {
                fatalError("Unexpected sender")
            }
            guard let indexPath = tableView.indexPath(for: senderDiscountCell) else {
                fatalError("Discount cell is not displayed")
            }
            
            let selectedDiscount = discounts[indexPath.row]
            
            // user can buy a discount only if he/she has enough coins on current balance
            
            if selectedDiscount.price! <= User.currentUser.currentBalance! {
                return true
                
            } else {
                errorMessage = "You don't have enough coins!"
            }
        }
        
        // present an alert telling user what went wrong
        
        let alertController = UIAlertController(title: "Discount can't be bought", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "buyDiscount" {
            
            // get our discount cell and moel
            
            guard let senderDiscountCell = sender as? DiscountTableViewCell else {
                fatalError("Unexpected sender")
            }
            guard let indexPath = tableView.indexPath(for: senderDiscountCell) else {
                fatalError("Discount cell is not displayed")
            }
            
            let selectedDiscount = discounts[indexPath.row]
            
            guard let discountVC = segue.destination as? DiscountViewController else {
                fatalError("Unexpected segue destination")
            }
            
            APIManager.shared.buyDiscount(userId: User.currentUser.id!, discountId: selectedDiscount.id!) {(json) in
                if json != nil {
                    User.currentUser.currentBalance! -= selectedDiscount.price!
                    User.currentUser.coinsSpent! += selectedDiscount.price!
                    
                    let discountRelativePath = json!["QR_image_URL"].string!
                    let discountQRImageURL = NSURL(string: BASE_URL)?.appendingPathComponent(discountRelativePath)
                    
                    discountVC.discountQRImageURL = discountQRImageURL
                } else {
                    fatalError("Server error, please try again later")
                }
            }
        }
    }
}
