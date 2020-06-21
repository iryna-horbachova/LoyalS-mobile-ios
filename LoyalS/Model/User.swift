import Foundation
import SwiftyJSON
import CoreLocation

class User {
    var id: String?
    var name: String?
    var email: String?
    var pictureURL: String?
    var currentBalance: Int?
    var coinsSpent: Int?
    var authtoken: String?
    
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
