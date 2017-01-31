//
//  JsonHotelParser.swift
//  HotelLister
//
//  Created by Nicholas Allio on 23/11/2016.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

//Helper structure with static values of parsing costants
struct JSONCostants {
    static let name = "name"
    static let address = "address"
    static let district = "district"
    static let city = "city"
    static let zipCode = "zipcode"
    static let starRating = "star_rating"
    static let reviewScore = "review_score"
}

class JsonHotelParser: NSObject {
    fileprivate let jsonFileName = "hotels"
    fileprivate var hotelsMap = [String:[Hotel]]()
    
    /**
     Parse the hotel.json file and return a dictionary with hotels groupped by city or nil if some error occurred.
     
     - Parameter completion: block with the resulted parsed dictionary in charge of handling the result.
     
     - Returns : no return value, completion block passed as parameter is executed.
     */
    func getHotels(_ completion: @escaping ([String:[Hotel]]?) -> () ) {
        let jsonURL = URL(fileURLWithPath: Bundle.main.path(forResource: jsonFileName, ofType: "json")!)
        DispatchQueue.global(qos: .background).async {
            do {
                let jsonData = try Data(contentsOf: jsonURL)
                let hotelList = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [[String:AnyObject]]
                
                for hotel in hotelList {
                    let newHotel = Hotel()
                    newHotel.name = hotel[JSONCostants.name] as? String
                    newHotel.address = hotel[JSONCostants.address] as? String
                    newHotel.district = hotel[JSONCostants.district] as? String
                    newHotel.city = hotel[JSONCostants.city] as? String
                    newHotel.zipCode = hotel[JSONCostants.zipCode] as? String
                    newHotel.starRating = hotel[JSONCostants.starRating] as? Int
                    if let score = hotel[JSONCostants.reviewScore] as? String {
                        newHotel.reviewScore = Float(score)
                    } else {
                        newHotel.reviewScore = 0.0
                    }
                    
                    if !self.hotelsMap.keys.contains(newHotel.city!) {
                        self.hotelsMap[newHotel.city!] = [Hotel]()
                    }
                    
                    self.hotelsMap[newHotel.city!]?.append(newHotel)
                }
                
                completion(self.hotelsMap)
                
            } catch {
                completion(nil)
            }

        }
    }

}
