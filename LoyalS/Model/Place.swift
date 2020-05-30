//
//  Place.swift
//  LoyalS
//

import Foundation
import SwiftyJSON

class Place {
    var id: Int?
    var title: String?
    var rating: Int?
    var address: String?
    var workingHours: String?
    var averageCost: String?
    var phone: String?
    var picture: String?
    var category: String?
    
    // initialize object from json data
    
    init(json: JSON) {
        self.id = json["id"].int
        self.title = json["title"].string
        self.rating = json["rating"].int
        self.address = json["address"].string
        self.picture = json["picture"].string
        self.workingHours = json["working_hours"].string
        self.averageCost = json["average_cost"].string
        self.phone = json["phone"].string
        self.category = json["category"].string
    }
}
