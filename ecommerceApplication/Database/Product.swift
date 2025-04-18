//
//  Products.swift
//  ecommerceApplication
//
//  Created by shankar singh on 29/03/2025.
//
import Foundation
import FirebaseFirestore

class Product{
    var id: String!
    var name: String
    var catgory: String
    var price: String
    var description: String
    var Image: String
    var stock: Int
    var registerAt: Timestamp!
    var quantity: Int = 1
    
    init(name: String, catgory: String, price: String, description: String, Image: String, stock: Int, registerAt: Timestamp, quantity: Int = 1) {
        self.name = name
        self.catgory = catgory
        self.price = price
        self.description = description
        self.Image = Image
        self.stock = stock
        self.registerAt = registerAt
        self.quantity = quantity
    }

    
   // Initializer with ID (used when loading from Firestore)
    convenience init(id: String, name: String, catgory: String, price: String, description: String, Image: String, stock: Int,registerAt: Timestamp, quantity: Int = 1) {
        self.init(name: name,
                  catgory: catgory,
                  price: price,
                  description: description,
                  Image: Image,
                  stock: stock,
                  registerAt: registerAt,
                  quantity: quantity)
        self.id = id
    }
    
    // Initializer by ID only
    convenience init(id: String) {
        self.init(name: "",
                  catgory: "",
                  price: "",
                  description: "",
                  Image: String(),
                  stock: 0,
                  registerAt: Timestamp(date: Date()),
                  quantity: 1)
        self.id = id
    }
    
    // Initializer from Firestore dictionary
    convenience init(id: String, dictionary: [String: Any]) {
        self.init(id: id,
                  name: dictionary["name"] as? String ?? "",
                  catgory: dictionary["catgory"] as? String ?? "",
                  price: dictionary["price"] as? String ?? "",
                  description: dictionary["description"] as? String ?? "",
                  Image: dictionary["Image"] as? String ?? "",
                  stock: dictionary["stock"] as? Int ?? 0,
                  registerAt: dictionary["registerAt"] as? Timestamp ?? Timestamp(date: Date()),
                  quantity: dictionary["quantity"] as? Int ?? 1)
    }
    
    func toString() -> String {
        return "id: \(id ?? "NO AUTOID"), name: \(name), category: \(catgory), price: \(price), description: \(description), imageUrls: \(Image), stock: \(stock),registerAt: \(registerAt) , quantity: \(quantity)"
    }
}

