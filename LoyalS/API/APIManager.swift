import Foundation
import Alamofire
import SwiftyJSON

// Class to manage API of app's backend

class APIManager {
    
    // MARK: - variables
    
    static let shared = APIManager()
    
    let baseURL = NSURL(string: BASE_URL)

    // MARK: - API to manage User account
    
    func register(idToken: String, completionHandler: @escaping () -> Void) {
        let url = baseURL!.appendingPathComponent(REGISTER_PATH)
        let headers: HTTPHeaders = [
            "authtoken": idToken
        ]
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding(), headers: headers).responseString {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                print("Success")
                print(jsonData)
                completionHandler()

                break
                
            case .failure(let error):
                print("Failure")
                print(error)
                break
            }
        }
    }
    
    func getUserInfo(idToken: String, completionHandler: @escaping (JSON) -> Void) {
        let url = baseURL!.appendingPathComponent(USER_INFO_PATH)
        let headers: HTTPHeaders = [
            "authtoken": idToken
        ]
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding(), headers: headers).responseString {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                completionHandler(jsonData)
                break
                
            case .failure(let error):
                print("Failure in getting user info")
                print(error)
                break
            }
        }
    }
    
    // MARK: - User checkin
    
    // send id of the user who makes a check in and id of the place where check in is made
    // get coins gained from this check in
    
    func checkIn(placeId: String, userId: String,  completionHandler: @escaping (JSON?) -> Void) {
        let url = baseURL!.appendingPathComponent(CHECKIN_PATH)
        let params: [String: Any] = [
            "place" : placeId,
            "user" : userId,
        ]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                completionHandler(jsonData)
                break
                
            case .failure(let error):
                print("Failure")
                print(error)
                break
            }
        }
    }
    
    // MARK: - Buying a discount
    
    // send userId and DiscountId
    // get generated QR_image_URL with needed discount
    
    func buyDiscount(userId: String, discountId: String, completionHandler: @escaping (JSON?) -> Void) {
        let url = baseURL!.appendingPathComponent(BUY_COUPON_PATH)
        let params : [String: Any] = [
            "userId" : userId,
            "discountId": discountId
        ]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                completionHandler(jsonData)
                break
                
            case .failure(let error):
                print("Failure")
                print(error)
                break
            }
        }
    }
    
    // MARK: - Get discounts used by user
    // send userID
    // get array of discounts
    
    func getUsedDiscounts(userId: String, completionHandler: @escaping (JSON) -> Void) {
        let url = baseURL!.appendingPathComponent(USED_COUPONS_PATH)
        let params: [String: Any] = [
            "userId": userId
        ]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                completionHandler(jsonData)
                break
                
            case .failure(let error):
                print("Failure")
                print(error)
                break
            }
        }
    }
    
    // MARK: - get all available duscounts for current user (discounts, which user did not used yet and which are suitable for current date)
    // send userID and city
    // get array of discounts
    
    func getAvailableDiscounts(userId: String, city: String, completionHandler: @escaping (JSON?) -> Void) {
        let url = baseURL!.appendingPathComponent(AVAILABLE_COUPONS_PATH)
        let params: [String: Any] = [
            "userId": userId,
            "city": city
        ]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                
                completionHandler(jsonData)
                break
                
            case .failure(let error):
                print("Failure")
                print(error)
                break
            }
        }
    }
    
    
    // MARK: - API to get list of places
    
    func getPlaces(category: String, city: String, completionHandler: @escaping (JSON?) -> Void) {
        let url = baseURL!.appendingPathComponent(PLACES_PATH)
      
        let params: [String: Any] = [
            "category": category,
            "city": city,
        ]
        
        let headers: HTTPHeaders = [
            "authtoken": User.currentUser.authtoken!
        ]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: headers).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                completionHandler(jsonData)
                break
                
            case .failure(let error):
                print("ERROR")
                print(error)
                completionHandler(nil)
                break
            }
        }
        
    }
    
    // MARK: - API to manage user's place suggestion
    
    func suggestPlace(userId: String, suggestedPlace: String, completionHandler: @escaping (JSON?) -> Void) {
        let url = baseURL!.appendingPathComponent(SUGGEST_PLACE_PATH)
        let params: [String: Any] = [
            "suggested_place" : suggestedPlace,
            "user" : userId,
            ]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                completionHandler(jsonData)
                break
                
            case .failure(let error):
                
                print("Failure")
                print(error)
                break
            }
        }
    }

}
