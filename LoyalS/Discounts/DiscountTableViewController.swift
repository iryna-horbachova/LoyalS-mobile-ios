import UIKit

class DiscountTableViewController: UITableViewController {
    
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
            
        }

        return cell
    }
}
