//
//  review.swift
//  ecommerceApplication
//
//  Created by shankar singh on 13/04/2025.
//

import Foundation
import FirebaseFirestore

class review{
    var id: String
    var userId: String
      var name: String
      var rating: Int
      var comment: String
      var timestamp: Timestamp!
    
    init(id: String, userId: String, name: String, rating: Int, comment: String, timestamp: Timestamp) {
        self.id = id
        self.userId = userId
        self.name = name
        self.rating = rating
        self.comment = comment
        self.timestamp = timestamp
    }
    convenience init?(id: String, dictionary: [String: Any]) {
        self.init(id: id,
                  userId: dictionary["userId"]as! String,
                  name: dictionary["name"] as! String,
                  rating: dictionary["rating"] as! Int,
                  comment: dictionary["comment"] as! String,
                  timestamp: dictionary["timestamp"] as! Timestamp)
        }

        // Optional: Convert to dictionary if you want to upload
        func toDictionary() -> [String: Any] {
            return [
                "userId": userId,
                "name": name,
                "rating": rating,
                "comment": comment,
                "timestamp": timestamp
            ]
        }
}
