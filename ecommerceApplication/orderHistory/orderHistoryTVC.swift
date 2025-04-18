//
//  orderHistoryTVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 18/04/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class orderHistoryTVC: UITableViewController {
    
    @IBOutlet var orderHistoryTVC: UITableView!
    var orders = [Order]()
    let service = Repository()
    let authUserId = Auth.auth().currentUser?.uid ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.fetchOrderHistory(for: authUserId) { fetchOrder in
            self.orders = fetchOrder
            self.orderHistoryTVC.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryTVCell", for: indexPath) as! orderHistoryTVCell
        let order = orders[indexPath.row]
        // Configure the cell...
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH-mm-ss -- dd-MM-yyyy"
        let date = formatter.string(from: order.orderDate.dateValue())
        
        cell.tittle.text = "Order: \(order.itemSummary)"
        cell.tittle?.numberOfLines = 0
        cell.tittle?.lineBreakMode = .byWordWrapping
        
        cell.dateTime.text = "Date: \(date)"
        cell.dateTime.font = UIFont.systemFont(ofSize: 14)
        cell.dateTime.textColor = .darkGray

        cell.status.text = "Status: \(order.status)"
        cell.status.font = UIFont.systemFont(ofSize: 14)
        cell.status.textColor = order.status == "Delivered" ? .systemGreen : .systemOrange

        cell.totalAmount.text = "Total Amount: $\(order.totalAmount)"
        cell.totalAmount.font = UIFont.boldSystemFont(ofSize: 14)
        cell.totalAmount.textColor = .systemBlue
        
        
        
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = .secondarySystemGroupedBackground

        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 4
        cell.layer.masksToBounds = false


        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
