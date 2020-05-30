//
//  APIManager.swift
//  LoyalS
//

import Foundation
import Alamofire
import SwiftyJSON

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
        print("IDTOKEN:")
        print(idToken)
        let headers: HTTPHeaders = [
            "authtoken": idToken
        ]
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding(), headers: headers).responseString {
            (response) in
            switch response.result {
            case .success(let value):
                print("Success in getUserInfo")
                print("not jsonData")
                print(value)
                print("jsonData")
                
                
                let jsonData = JSON(value)
                print(jsonData)
                
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
    
    func checkIn(placeId: String, userId: String, coins: Int, completionHandler: @escaping () -> Void) {
        let url = baseURL!.appendingPathComponent(CHECKIN_PATH)
        let params: [String: Any] = [
            "place" : placeId,
            "user" : userId,
            "coins" : coins
        ]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
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
    
    // MARK: - Buying a coupon
    
    func buyCoupon(userId: String, couponId: String, completionHandler: @escaping () -> Void) {
        let url = baseURL!.appendingPathComponent(BUY_COUPON_PATH)
        let params : [String: Any] = [
            "userId" : userId,
            "couponId": couponId
        ]
        
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                //let jsonData = JSON(value)
                
                completionHandler()
                break
                
            case .failure(let error):
                print("Failure")
                print(error)
                break
            }
        }
    }
    
    // MARK: - Get coupons used by user
    
    func getUsedCoupons(userId: String, completionHandler: @escaping (JSON) -> Void) {
        let url = baseURL!.appendingPathComponent(USED_COUPONS_PATH)
        let params: [String: Any] = [
            "userId": userId
        ]
        
        Alamofire.request(url!, method: .get, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON {
            (response) in
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                print(jsonData)
                
                completionHandler(jsonData)
                break
                
            case .failure(let error):
                print("Failure")
                print(error)
                break
            }
        }
    }
    
    // MARK: - User checkin
    
    func getAvailableCoupons(userId: String, completionHandler: @escaping (JSON) -> Void) {
        let url = baseURL!.appendingPathComponent(AVAILABLE_COUPONS_PATH)
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

}
