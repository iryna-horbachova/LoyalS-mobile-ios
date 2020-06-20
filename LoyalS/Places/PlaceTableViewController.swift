//
//  PlaceTableViewController.swift
//  LoyalS
//

import UIKit
import CoreLocation

class PlaceTableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    // MARK: - Variables

    var userLocation = "Kharkiv"
    var category: Category?
    var places = [Place]()
    var filteredPlaces = [Place]()
    var isSearchBarEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    var locationManager: CLLocationManager!
    
    // MARK: - Outlets
    
    let activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableViewOutlet: UITableView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.navigationItem.title = category?.title
        
        // get user's location
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        
        guard let exposedLocation = locationManager.location else {
            print("*** Error in \(#function): exposedLocation is nil")
            return
        }
        
        locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            
            if let city = placemark.locality {
                self.userLocation = city
                print(self.userLocation)
            }
            
        }
        
        loadPlaces()
    }
    
    
    // MARK: - Methods
    
    func loadPlaces() {
        Utilities.showActivityIndicator(activityIndicator, view)
        APIManager.shared.getPlaces(category: (category?.id)!, city: userLocation) { (json) in
            if json != nil {
                self.places = []
                
                if let listPlaces = json!.array {
                    for item in listPlaces {
                        let place = Place(json: item)
                        self.places.append(place)
                    }
                    // CHECK IF ITS OKAY TO USE THIS VARIABLE
                    self.tableView.reloadData()
                }
            } else {
                print("Unfortunately no places were found")
                let alertController = UIAlertController(title: "No places", message: "Unfortunately no places were found based on your preferences" , preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPlaces = places.filter({ (place: Place) -> Bool in
            return place.title?.lowercased().range(of: searchText.lowercased()) != nil
        })
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearchBarEmpty {
            return filteredPlaces.count
        }
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceTableViewCell
        
        let place: Place
        place = isSearchBarEmpty ? places[indexPath.row] : filteredPlaces[indexPath.row]
        
        cell.titleLabel.text = place.title!
        cell.ratingLabel.text = String(place.rating!)
        cell.distanceLabel.text = "0.5"
        //cell.placeImageLogo = place.logo
        if let picture = place.picture {
            let placeURL = NSURL(string: BASE_URL)?.appendingPathComponent(picture)
            
            Utilities.loadImage(imageView: cell.placeImageLogo, imageURL: placeURL!)
        }
  
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placeDetailsIdentifier" {
            
            guard let placeDetailsVC = segue.destination as? PlaceViewController else {
                fatalError("Unexpected segue destination")
            }
            
            guard let senderPlaceCell = sender as? PlaceTableViewCell else {
                fatalError("Unexpected sender")
            }
            
            guard let indexPath = tableView.indexPath(for: senderPlaceCell) else {
                fatalError("Place cell is not displayed")
            }
            
            let selectedPlace = isSearchBarEmpty ? places[indexPath.row] : filteredPlaces[indexPath.row]
            placeDetailsVC.place = selectedPlace
            
        }
    }
    

}
