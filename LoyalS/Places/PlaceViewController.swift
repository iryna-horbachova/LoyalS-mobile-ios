import UIKit
import MapKit
import CoreLocation

class PlaceViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Variables
    
    var place: Place?
    var locationManager: CLLocationManager!
    var placeLocation: CLLocation!
    
    // MARK: - Outlets
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var map: MKMapView!
    
    
    // MARK: - Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPlace()
        
        // Showing user's location
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            self.map.showsUserLocation = true
        }
        
        showPlaceOnMap()
    }
    
    // MARK: - Methods
    
    func loadPlace() {
        if let place = place {
            navigationItem.title = place.title
            
            hoursLabel.text = place.workingHours
            moneyLabel.text = place.averageCost
            ratingLabel.text = String(place.rating!)
            phoneLabel.text = place.phone
            
            if let picture = place.picture {
                let placeURL = NSURL(string: BASE_URL)?.appendingPathComponent(picture)
                
                Utilities.loadImage(imageView: imageView, imageURL: placeURL!)
            }
        }
    }
    
    func showPlaceOnMap() {
        if let address = place?.address {
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if (error == nil) {
                    if let placemark = placemarks?.first {
                        self.placeLocation = placemark.location!
                        let coordinates: CLLocationCoordinate2D = self.placeLocation.coordinate
                        
                        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        
                        self.map.setRegion(region, animated: true)
                        self.locationManager.stopUpdatingLocation()
                    }
                }
            }
        }
    }
    
    // MARK: - Managing location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var errorMessage = "Invalid segue identifier :("
        if identifier == "userCheckIn" {
            // user can perform check in only within range of the place's specified location
            
            if let userLocation = locationManager.location {
                if userLocation.distance(from: placeLocation) < 10 {
                    return true
                } else {
                    errorMessage = "You must be in this place to make a checkin!"
                }
            } else {
                errorMessage = "You must enable this application to access location to make checkins!"
            }

        }
        
        // present an alert telling user what went wrong
        
        let alertController = UIAlertController(title: "Checkin can't be made", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userCheckIn" {
            // send data of coins gained from our API to destination CheckInViewController
            
            guard let checkInVC = segue.destination as? CheckInViewController else {
                fatalError("Unexpected segue destination")
            }
            
            APIManager.shared.checkIn(placeId: (place?.id)!, userId: User.currentUser.id!) {(json) in
                if json != nil {
                    let coinsGained = json!["coins_gained"].int
                    User.currentUser.currentBalance! += coinsGained!
                    checkInVC.coinsGained = coinsGained
                } else {
                    fatalError("Server error, please try again later")
                }
            }
        }
    }

}
