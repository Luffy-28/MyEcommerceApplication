//
//  ProductRepository.swift
//  ecommerceapp
//
//  Created by shankar singh on 06/04/2025.
//

import Foundation
import FirebaseFirestore

class Repository {
    var db = Firestore.firestore()
    
    // MARK: - USER METHODS
    
    func addUser(withData user: User) -> Bool {
        var result = true
        let dictionary: [String: Any] = [
            "name": user.name,
            "email": user.email,
            "phone": user.phone,
            "address": user.address,
            "photo": user.photo
        ]
        
        db.collection("User").document(user.id).setData(dictionary) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
                result = false
            } else {
                print("User added: \(user.email)")
            }
        }
        
        return result
    }
    
    func updateUser(withData user: User, completion: @escaping (Bool) -> Void) {
        let dictionary: [String: Any] = [
            "name": user.name,
            "email": user.email,
            "phone": user.phone,
            "address": user.address,
            "photo": user.photo
        ]
        
        db.collection("User").document(user.id).updateData(dictionary) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
                completion(false)
            } else {
                print("User updated successfully")
                completion(true)
            }
        }
    }

    
    func findUserInfo(for userId: String, completion: @escaping (User?) -> ()) {
        let userRef = db.collection("User").document(userId)
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting user info: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let document = document, document.exists, let data = document.data() else {
                print("User document does not exist")
                completion(nil) //  Important
                return
            }

            let user = User(id: document.documentID, dictionary: data)
            completion(user)
        }
    }

    
    
    // MARK: - PRODUCT METHODS
    
    func fetchAllProducts(fromCollection name: String, completion: @escaping ([Product]) -> ()) {
        var products = [Product]()
        _ = db.collection(name).order(by: "name").order(by: "price", descending: false).addSnapshotListener { snapshot, error in
            if let documents = snapshot?.documents {
                products = documents.compactMap({ doc -> Product? in
                    let data = doc.data()
                    return Product(id: doc.documentID, dictionary: data)
                })
                for product in products {
                    print(product.toString())
                }
                completion(products)
            }else{
                print("Error fetching products \(error!)")
                return
            }
        }
    }
    func addProduct(withData product: Product) -> Bool {
        var result = true
        let dictionary: [String: Any] = [
            "name": product.name,
            "catgory": product.catgory,
            "price": product.price,
            "description": product.description,
            "Image": product.Image,
            "stock": product.stock,
        ]
        
        db.collection("Product").document(product.id).setData(dictionary) { error in
            if let error = error {
                print("Error adding product: \(error.localizedDescription)")
                result = false
            } else {
                print("Product added")
            }
        }
        return result
    }
    
    func updateProduct(withData product: Product) -> Bool {
        var result = true
        let dictionary: [String: Any] = [
            "name": product.name,
            "catgory": product.catgory,
            "price": product.price,
            "description": product.description,
            "Image": product.Image,
            "stock": product.stock,
        ]
        
        self.db.collection("Product").document(product.id!).updateData(dictionary) { error in
            if let error = error {
                print("Error updating product: \(error.localizedDescription)")
                result = false
            } else {
                print("Product updated")
            }
        }
        
        return result
    }
    
    func deleteProduct(withProductId productId: String) -> Bool {
        var result = true
        self.db.collection("Product").document(productId).delete { error in
            if let error = error {
                print("Error deleting product: \(error.localizedDescription)")
                result = false
            } else {
                print("Product deleted")
            }
        }
        return result
    }
    
    // MARK: - WISHLIST METHODS
    func addToWishlist(for userId: String, withData product: Product) -> Bool {
        var result = true
        let dictionary: [String: Any] = [
            "productId": product.id!,
            "name": product.name,
            "price": product.price,
            "Image": product.Image,
            "catgory": product.catgory,
            "registeredAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("User").document(userId).collection("wishlist").document(product.id!).setData(dictionary) { error in
            if let error = error {
                print("Error adding to wishlist: \(error.localizedDescription)")
                result = false
            } else {
                print("Added to wishlist")
            }
        }
        
        return result
    }
    
    func deleteFromWishlist(for userId: String, withProductId productId: String, completion: @escaping (Bool) -> Void) {
        db.collection("User").document(userId).collection("wishlist").document(productId).delete { error in
            if let error = error {
                print("Error deleting from wishlist: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Removed from wishlist")
                completion(true)
            }
        }
    }

    
    // MARK: - CART METHODS
    
    func addToCart(for userId: String, withData product: Product, quantity: Int, completion: @escaping (Bool) -> Void) {
        let productId = product.id ?? UUID().uuidString
        let cartRef = db.collection("User").document(userId).collection("cart").document(productId)
        
        cartRef.getDocument { document, error in
            if let error = error {
                print("Error checking cart: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let document = document, document.exists {
                // Product already exists → update quantity
                let currentQty = document.data()?["quantity"] as? Int ?? 0
                let newQty = currentQty + quantity
                cartRef.updateData(["quantity": newQty]) { error in
                    if let error = error {
                        print("Error updating quantity: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Quantity updated to \(newQty)")
                        completion(true)
                    }
                }
            } else {
                // Product not in cart → add new
                let dictionary: [String: Any] = [
                    "productId": productId,
                    "name": product.name,
                    "price": product.price,
                    "quantity": quantity,
                    "Image": product.Image,
                    "catgory": product.catgory,
                    "registeredAt": FieldValue.serverTimestamp()
                ]
                
                cartRef.setData(dictionary) { error in
                    if let error = error {
                        print("Error adding to cart: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Product added to cart")
                        completion(true)
                    }
                }
            }
        }
    }
    func checkoutCart(for userId: String, completion: @escaping (Bool) -> Void) {
            let userRef = db.collection("User").document(userId)
            let cartRef = userRef.collection("cart")

            cartRef.getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    completion(false)
                    return
                }

                var orderedItems: [[String: Any]] = []
                var totalAmount: Double = 0.0

                for doc in documents {
                    let data = doc.data()

                    if let name = data["name"] as? String,
                       let priceStr = data["price"] as? String,
                       let price = Double(priceStr),
                       let quantity = data["quantity"] as? Int {

                        orderedItems.append([
                            "name": name,
                            "price": price,
                            "quantity": quantity
                        ])

                        totalAmount += price * Double(quantity)
                    }
                }

                let orderData: [String: Any] = [
                    "userId": userId,
                    "items": orderedItems,
                    "orderDate": Timestamp(date: Date()),
                    "totalAmount": totalAmount
                ]

                userRef.collection("orders").addDocument(data: orderData) { error in
                    if error != nil {
                        completion(false)
                        return
                    }

                    let batch = self.db.batch()
                    for doc in documents {
                        batch.deleteDocument(cartRef.document(doc.documentID))
                    }

                    batch.commit { error in
                        completion(error == nil)
                    }
                }
            }
        }

    func reduceProductStock(productId: String, quantityToReduce: Int) {
        let productRef = db.collection("Product").document(productId)
        productRef.getDocument { document, error in
            if let document = document, document.exists {
                let currentStock = document.data()?["stock"] as? Int ?? 0
                let updatedStock = max(currentStock - quantityToReduce, 0)
                productRef.updateData(["stock": updatedStock]) { error in
                    if let error = error {
                        print("Failed to update stock: \(error.localizedDescription)")
                    } else {
                        print("Stock updated for product \(productId)")
                    }
                }
            }
        }
    }
    func updateCartQuantity(for userId: String, productId: String, newQuantity: Int, completion: @escaping (Bool) -> Void) {
        let productRef = db.collection("User").document(userId).collection("cart").document(productId)

        productRef.updateData(["quantity": newQuantity]) { error in
            completion(error == nil)
        }
    }

    
    func deleteFromCart(for userId: String, withProductId productId: String, completion: @escaping (Bool) -> Void) {
        db.collection("User").document(userId).collection("cart").document(productId).delete { error in
            if let error = error {
                print("Error deleting from cart: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Removed from cart")
                completion(true)
            }
        }
    }
    
    // MARK: - FETCH CART
    func fetchCart(for userId: String, completion: @escaping ([Product]) -> Void) {
        var cartItems = [Product]()
        
        db.collection("User").document(userId).collection("cart").addSnapshotListener { snapshot, error in
            if let documents = snapshot?.documents {
                cartItems = documents.compactMap({ doc -> Product? in
                    var data = doc.data()
                    data["id"] = doc.documentID  // Inject the ID if needed
                    return Product(id: doc.documentID, dictionary: data)
                })
                completion(cartItems)
            } else {
                print("Error fetching cart: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
            }
        }
    }

    // MARK: - FETCH WISHLIST
    func fetchWishlist(for userId: String, completion: @escaping ([Product]) -> Void) {
        var wishlistItems = [Product]()
        
        db.collection("User").document(userId).collection("wishlist").addSnapshotListener { snapshot, error in
            if let documents = snapshot?.documents {
                wishlistItems = documents.compactMap({ doc -> Product? in
                    var data = doc.data()
                    data["id"] = doc.documentID  // Inject the ID if needed
                    return Product(id: doc.documentID, dictionary: data)
                })
                completion(wishlistItems)
            } else {
                print("Error fetching wishlist: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
            }
        }
    }
    func addReview(for productId: String, review: review, completion: @escaping (Bool) -> Void) {
            db.collection("Product")
                .document(productId)
                .collection("reviews")
                .addDocument(data: review.toDictionary()) { error in
                    if let error = error {
                        print("Error adding review: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Review added")
                        completion(true)
                    }
                }
        }

        // MARK: - Fetch Reviews
        func fetchReviews(for productId: String, completion: @escaping ([review]) -> Void) {
            db.collection("Product")
                .document(productId)
                .collection("reviews")
                .order(by: "timestamp", descending: true)
                .getDocuments { snapshot, error in
                    var reviews: [review] = []
                    if let documents = snapshot?.documents {
                        for doc in documents {
                            if let reviewObj = review(id: doc.documentID, dictionary: doc.data()) {
                                reviews.append(reviewObj)
                            }
                        }
                    } else {
                        print("Error fetching reviews: \(error?.localizedDescription ?? "Unknown error")")
                    }
                    completion(reviews)
                }
        }

        // MARK: - Delete Review (Optional)
        func deleteReview(for productId: String, reviewId: String, completion: @escaping (Bool) -> Void) {
            db.collection("Product")
                .document(productId)
                .collection("reviews")
                .document(reviewId)
                .delete { error in
                    if let error = error {
                        print("Error deleting review: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Review deleted")
                        completion(true)
                    }
                }
        }
    func fetchOrderHistory(for userId: String, completion: @escaping ([Order]) -> Void) {
        db.collection("User")
            .document(userId)
            .collection("orders")
            .order(by: "orderDate", descending: true)
            .getDocuments { snapshot, error in
                var orders: [Order] = []
                if let documents = snapshot?.documents {
                    for doc in documents {
                        if let order = Order(id: doc.documentID, dictionary: doc.data()) {
                            orders.append(order)
                        }
                    }
                }
                completion(orders)
            }
    }
    
    func updateOrderStatusIfNeeded(order: Order, userId: String) {
        let currentDate = Date()
        let deliveryDate = order.orderDate.dateValue().addingTimeInterval(5 * 24 * 60 * 60)

        if currentDate >= deliveryDate {
            let orderRef = db.collection("User")
                             .document(userId)
                             .collection("orders")
                             .document(order.id)

            orderRef.updateData(["status": "Delivered"])
        }
    }


}

             
