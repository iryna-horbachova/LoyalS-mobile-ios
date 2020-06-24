import Foundation
import SwiftyJSON
import CoreLocation

class User {
    var id: String? = "1"
    var name: String? = "1"
    var email: String? = "1"
    var pictureURL: String? = "1"
    var currentBalance: Int? = 1
    var coinsSpent: Int? = 1
    var authtoken: String? = "1"
    
    var currentLocation: String?
    static var defaultLocation = "Kharkiv, Ukraine"
    
    static let currentUser = User()
    
    // initialize object from json data
    
    func setInfo(json: JSON, authtoken: String) {
        self.id = json["id"].string
        self.name = json["name"].string
        self.email = json["email"].string
        
        self.currentBalance = json["current_balance"].int
        self.coinsSpent = json["coins_spent"].int
        
        self.pictureURL = json["photo_path"].string
        
        self.authtoken = authtoken
    }
    
    func resetInfo() {
        self.id = nil
        self.name = nil
        self.email = nil
        
        self.currentBalance = nil
        self.coinsSpent = nil
        
        self.pictureURL = nil
        self.currentLocation = nil
    }
    
}
