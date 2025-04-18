//
//  checkOutTVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 15/04/2025.
//

import UIKit
import FirebaseAuth

class checkOutTVC: UITableViewController {

    @IBOutlet var checkoutTVC: UITableView!
    
    @IBOutlet weak var emaiLabel: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtNumber: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    let service = Repository()
       let authUserId = Auth.auth().currentUser?.uid ?? ""
       var cartProducts = [Product]()
       var user : User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Load user profile details
        print("Auth User ID: \(authUserId)")

        service.findUserInfo(for: authUserId) { user in
            if let user = user {
                self.user = user
                DispatchQueue.main.async {
                    self.emaiLabel.text = user.email
                    self.txtName.text = user.name
                    self.txtNumber.text = user.phone
                    self.txtAddress.text = user.address
                }
            } else {
                print("No user found for ID: \(self.authUserId)")
            }
        }

        service.fetchCart(for: authUserId) { products in
            self.cartProducts = products
            print("Fetched \(products.count) cart items")
            for p in products {
                print("\(p.name) - \(p.quantity)")
            }
        }

            }

    @IBAction func confirmOrderButtonTApped(_ sender: Any) {
        
        for product in cartProducts {
            service.reduceProductStock(productId: product.id, quantityToReduce: product.quantity)
        }
        
        // Optional: Clear the user's cart after order
        service.clearCart(for: authUserId)
        
        // Show confirmation alert
        let alert = UIAlertController(
            title: "Order Confirmed",
            message: "Your order has been placed and will be delivered at:\n\(txtAddress.text ?? "")",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
