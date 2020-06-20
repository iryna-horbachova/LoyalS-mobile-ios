import Foundation
import UIKit
import SwiftyJSON
import CoreLocation

class Utilities {
    
    // Function to fetch image via network and make it specified UIImage
    
    static func loadImage(imageView: UIImageView, imageURL: URL) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let urlContents = try? Data(contentsOf: imageURL)
            // UI stuff can e done only in main queue
            DispatchQueue.main.async {
                if let imageData = urlContents {
                    imageView.image = UIImage(data: imageData)
                    
                }
            }
        }
    }
    
    // Function to show and hide UIActivityIndicator on page load
    
    static func showActivityIndicator(_ activityIndicator: UIActivityIndicatorView, _ view: UIView) {
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.color = UIColor.black
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    static func hideActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - User validation 
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        let minPasswordLength = 8
        return password.count >= minPasswordLength
    }
    
}

// Extension to get contents for segue.destination

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}


// Extension to format JSON dates

extension JSON {
    static let jsonDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter
    }()
}

// Extension to get user's city

extension CLLocationManager {
    
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}
