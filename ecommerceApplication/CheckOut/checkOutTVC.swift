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
            if product.stock == 0 {
                service.reduceProductStock(productId: product.id, quantityToReduce: product.quantity)
            }
            service.checkoutCart(for: authUserId) { success in
                DispatchQueue.main.async {
                    if success {
                        // Step 1: Show alert
                        let alert = UIAlertController(
                            title: "Success",
                            message: "Your order has been placed successfully!",
                            preferredStyle: .alert
                        )
                        
                        // Step 2: Redirect to HomeVC when OK is tapped
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! UITabBarController
                            self.view.window?.rootViewController = homeVC
                            self.view.window?.makeKeyAndVisible()
                        }))
                        
                        self.present(alert, animated: true)
                    } else {
                        self.showAlertMessage(tittle: "Error", message: "Something went wrong. Please try again.")
                    }
                }
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
    }
}
