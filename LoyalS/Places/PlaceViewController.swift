//
//  PlaceViewController.swift
//  LoyalS
//

import UIKit
import MapKit
import CoreLocation

class PlaceViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Variables
    
    var place: Place?
    var locationManager: CLLocationManager!
    
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
                        let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                        
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

}
