//
//  wishlistTVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 13/04/2025.
//

import UIKit
import FirebaseAuth

class wishlistTVC: UITableViewController {
    var service = Repository()
     var products = [Product]()
    let userAuthId = Auth.auth().currentUser!.uid
    
    @IBOutlet var wishlistTVC: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        service.fetchWishlist(for: userAuthId) { (returnCollection) in
            self.products = returnCollection
            self.wishlistTVC.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! wishlistTVCell
        let product = products[indexPath.row]
        cell.nameLabel.text = product.name
        cell.pricelabel.text = "$\(product.price)"
        // for the picture
        if !product.Image.isEmpty && UIImage(named: product.Image) != nil {
            cell.photoImageView.image = UIImage(named: product.Image)
            
        }else{
            // place a default picture
            cell.photoImageView.image = UIImage(systemName: "person.circle.fill")
        }
        cell.photoImageView.layer.cornerRadius = cell.photoImageView.frame.size.width / 2
        cell.photoImageView.clipsToBounds = true

        // Configure the cell...

        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            guard row < products.count else { return }

            let product = products[row]

            deleteConfirmationMessage(
                title: "Delete Item",
                message: "Are you sure you want to delete \(product.name)?",
                delete: { [weak self] in
                    guard let self = self else { return }

                    // Corrected to delete from wishlist
                    self.service.deleteFromWishlist(for: self.userAuthId, withProductId: product.id) { success in
                        if success {
                            DispatchQueue.main.async {
                                // Refetch updated wishlist
                                self.service.fetchWishlist(for: self.userAuthId) { updatedWishlist in
                                    self.products = updatedWishlist
                                    self.tableView.reloadData()

                                    // Optional: show "wishlist is empty"
                                    if self.products.isEmpty {
                                        let label = UILabel()
                                        label.text = "Your wishlist is empty"
                                        label.textAlignment = .center
                                        label.textColor = .lightGray
                                        self.tableView.backgroundView = label
                                    } else {
                                        self.tableView.backgroundView = nil
                                    }
                                }
                            }
                        } else {
                            print("Failed to delete item from wishlist")
                        }
                    }
                },
                cancel: {
                    print("Cancelled deletion")
                }
            )
        }
    }

    

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
