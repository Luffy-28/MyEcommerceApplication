//
//  Products.swift
//  ecommerceApplication
//
//  Created by shankar singh on 29/03/2025.
//
import Foundation
import FirebaseFirestore

class Products {
    var id: String!
    var name: String
    var category: String
    var price: Double
    var description: String
    var imageUrl: String
    var stock: Int
    var registerAt: Timestamp!
    var review: String
    
    init(name: String, category: String, price: Double, description: String, imageUrl: String, stock: Int, registerAt: Timestamp, review: String) {
        self.name = name
        self.category = category
        self.price = price
        self.description = description
        self.imageUrl = imageUrl
        self.stock = stock
        self.registerAt = registerAt
        self.review = review
    }

    
   // Initializer with ID (used when loading from Firestore)
    convenience init(id: String, name: String, category: String, price: Double, description: String, imageUrl: String, stock: Int,registerAt: Timestamp,review: String) {
        self.init(name: name,
                  category: category,
                  price: price,
                  description: description,
                  imageUrl: imageUrl,
                  stock: stock,
                  registerAt: registerAt,
                  review: review)
        self.id = id
    }
    
    // Initializer by ID only
    convenience init(id: String) {
        self.init(name: "",
                  category: "",
                  price: 0.0,
                  description: "",
                  imageUrl: String(),
                  stock: 0,
                  registerAt: Timestamp(date: Date()),
                  review: "")
        self.id = id
    }
    
    // Initializer from Firestore dictionary
    convenience init(id: String, dictionary: [String: Any]) {
        self.init(id: id,
                  name: dictionary["name"] as? String ?? "",
                  category: dictionary["category"] as? String ?? "",
                  price: dictionary["price"] as? Double ?? 0.0,
                  description: dictionary["description"] as? String ?? "",
                  imageUrl: dictionary["imageUrl"] as? String ?? "",
                  stock: dictionary["stock"] as? Int ?? 0,
                  registerAt: dictionary["registerAt"] as? Timestamp ?? Timestamp(date: Date()),
                  review: dictionary["review"] as? String ?? "")
    }
    
    func toString() -> String {
        return "id: \(id ?? "NO AUTOID"), name: \(name), category: \(category), price: \(price), description: \(description), imageUrls: \(imageUrl), stock: \(stock),registerAt: \(registerAt) ,review: \(review)"
    }
}

