import UIKit

// Class to display static categories of places

class CategoryTableViewController: UITableViewController {
    
    // MARK: - variables
    
    var categories: [Category]?
    
    // MARK: - Application Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let cafe = Category(title: "Food", image: UIImage(named: "category-cafe")!, id: "food")
        let museum = Category(title: "Museums & Galleries", image: UIImage(named: "category-museum")!, id: "museums")
        let hotel = Category(title: "Hotels", image: UIImage(named: "category-hotel")!, id: "hotels")
        let entertainment = Category(title: "Entertainment", image: UIImage(named: "category-entertainment")!, id: "entertainment")
        
        categories = [
            cafe, museum, hotel, entertainment
        ]
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        if let cell = cell as? CategoryTableViewCell {
            if let category = categories?[indexPath.row] {
                cell.categoryLabel.text = category.title
                cell.categoryImageView.image = category.image
                cell.categoryImageView?.clipsToBounds = true
              //  cell.categoryImageView?.contentMode = .scaleAspectFit
            }
        }

        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showPlacesIdentifier" {
            if let placesVC = segue.destination.contents as? PlaceTableViewController {
                
                guard let senderCategoryCell = sender as? CategoryTableViewCell else {
                    fatalError("Unexpected sender")
                }
                
                guard let indexPath = tableView.indexPath(for: senderCategoryCell) else {
                    fatalError("Place cell is not displayed")
                }
                
                placesVC.category = categories![indexPath.row]
            }
        }
    }
}


