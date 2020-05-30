//
//  Discount.swift
//  LoyalS
//


import Foundation
import SwiftyJSON

class Discount {
    var id: String?
    var title: String?
    var startDate: Date?
    var endDate: Date?
    var category: String?
    var place: String?
    var price: Int?
    
    // initialize object from json data
    
    init(json: JSON) {
        self.id = json["id"].string
        self.title = json["title"].string
        self.startDate = JSON.jsonDateFormatter.date(from: json["start_date"].string!)
        self.endDate = JSON.jsonDateFormatter.date(from: json["end_date"].string!)
        self.category = json["category"].string
        self.place = json["place"].string
        self.price = json["price"].int
    }
}
