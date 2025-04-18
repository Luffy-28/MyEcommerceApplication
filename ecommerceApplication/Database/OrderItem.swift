class OrderedItem {
    var name: String
    var price: Double
    var quantity: Int
   

    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }

    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let price = dictionary["price"] as? Double,
              let quantity = dictionary["quantity"] as? Int
              else {
            return nil
        }
        self.name = name
        self.price = price
        self.quantity = quantity
    }

    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "price": price,
            "quantity": quantity,
        ]
    }
}
