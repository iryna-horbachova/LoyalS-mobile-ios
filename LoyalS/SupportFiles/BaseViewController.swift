import UIKit
import CoreLocation


// Base class for Places- and Discounts- TableViewControllers (with location functionality)

class BaseViewController: UITableViewController, CLLocationManagerDelegate {
    
    // MARK: - Variabled

    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserLocation()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Function to set user's location if it is equal to nil
    
    func setUserLocation() {
        if User.currentUser.currentLocation == nil {
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
                    User.currentUser.currentLocation = city
                }
                
            }
        }
    }
}
