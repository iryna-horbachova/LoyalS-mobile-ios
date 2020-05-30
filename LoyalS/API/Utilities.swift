//
//  Utilities.swift
//  LoyalS
//
//  Created by Irachka on 5/28/20.
//  Copyright © 2020 Iryna. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Utilities {
    
    // Function to fetch image via network and make it specified UIImage
    
    static func loadImage(imageView: UIImageView, imageURL: URL) {
        //let imageURL: URL = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async(execute: {
                imageView.image = UIImage(data: data)
            })
            }.resume()
        
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
