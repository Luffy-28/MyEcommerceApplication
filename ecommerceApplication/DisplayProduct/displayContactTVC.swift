//
//  displayContactTVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 11/04/2025.
//

import UIKit
import FirebaseAuth

class displayContactTVC: UITableViewController, ProductActionDelegate {
    func didTapAddToCart(product: Product) {
        service.addToCart(for: userAuthId, withData: product, quantity: 1) { success in
            DispatchQueue.main.async {
                if success {
                    self.showAlert(message: "\(product.name) added to cart.")
                } else {
                    self.showAlert(message: "Failed to add to cart.")
                }
            }
        }
    }

    
    func didTapAddToWishlist(product: Product) {
        let success = service.addToWishlist(for: userAuthId, withData: product)
        if success{
            showAlert(message: "\(product.name) added to Wishlist.")
        }else{
            showAlert(message: "Failed to add to cart.")

        }
    }
    

    @IBOutlet var displayContactTVC: UITableView!
    let service = Repository()
    var products = [Product]()
    let userAuthId = Auth.auth().currentUser!.uid
    var selectedProduct : Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        service.fetchAllProducts(fromCollection: "Product") { (returnedCollection) in
            self.products = returnedCollection
            self.displayContactTVC.reloadData()
        }
        print("total\(products.count)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! displayContactTVCell

        let product = products[indexPath.row]
        cell.productName.text = product.name
        cell.delegate = self
        cell.productPrice.text = "$\(product.price)"
        cell.product = product
        
        // for the picture
        if !product.Image.isEmpty && UIImage(named: product.Image) != nil {
            cell.photoImageView.image = UIImage(named: product.Image)
            
        }else{
            // place a default picture
            cell.photoImageView.image = UIImage(systemName: "person.circle.fill")
        }
        cell.photoImageView.layer.cornerRadius = cell.photoImageView.frame.size.width / 2
        cell.photoImageView.clipsToBounds = true

        return cell
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(indexPath.row)
        selectedProduct = products[indexPath.row]
        return indexPath
    }
    

 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let productDetialTVC = segue.destination as? productDetialTVC{
            productDetialTVC.products = selectedProduct
        }
    }
   
            
    @IBAction func unwindTodisplayCOntactTVC(_ unwindSegue: UIStoryboardSegue){
        let sourceViewController = unwindSegue.source
    }
    

}
