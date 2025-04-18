import Foundation
import FirebaseFirestore

class Order {
    var id: String!
    var userId: String
    var items: [OrderedItem]
    var orderDate: Timestamp
    var totalAmount: Double

    // Computed status: Delivered after 5 days
    var status: String {
        let currentDate = Date()
        let deliveryDate = orderDate.dateValue().addingTimeInterval(5 * 24 * 60 * 60)
        return currentDate >= deliveryDate ? "Delivered" : "Pending"
    }

    // MARK: - Initializer
    init(id: String, userId: String, items: [OrderedItem], orderDate: Timestamp, totalAmount: Double) {
        self.id = id
        self.userId = userId
        self.items = items
        self.orderDate = orderDate
        self.totalAmount = totalAmount
    }

    // MARK: - Firestore Initializer
    convenience init?(id: String, dictionary: [String: Any]) {
        guard let userId = dictionary["userId"] as? String,
              let itemsArray = dictionary["items"] as? [[String: Any]],
              let orderDate = dictionary["orderDate"] as? Timestamp,
              let totalAmount = dictionary["totalAmount"] as? Double else {
            return nil
        }

        let items = itemsArray.compactMap { OrderedItem(dictionary: $0) }
        self.init(id: id, userId: userId, items: items, orderDate: orderDate, totalAmount: totalAmount)
    }

    // MARK: - Firestore Dictionary
    func toDictionary() -> [String: Any] {
        let itemsDictArray = items.map { $0.toDictionary() }
        return [
            "userId": userId,
            "items": itemsDictArray,
            "orderDate": orderDate,
            "totalAmount": totalAmount
        ]
    }

    var itemSummary: String {
        return items.map { "\($0.name) x\($0.quantity)" }.joined(separator: ", ")
    }

    func toString() -> String {
        var itemList = items.map { "\($0.name)x\($0.quantity)" }.joined(separator: ", ")
        return "user: \(userId)\nitems: \(itemList)\ntotal: \(totalAmount)\nstatus: \(status)"
    }
}
