//
//  displayContactTVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 11/04/2025.
//

import UIKit
import FirebaseAuth

class displayContactTVC: UITableViewController, ProductActionDelegate, UISearchBarDelegate {
    func didTapAddToCart(product: Product) {
        if product.stock == 0 {
            showToast("\(product.name) is out of stock")
                return
            }
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
    
    
    
    @IBOutlet weak var UisearchBar: UISearchBar!
    
    var searching = false
    
    
    @IBOutlet var displayContactTVC: UITableView!
    let service = Repository()
    var products = [Product]()
    var filteredProducts = [Product]()
    let userAuthId = Auth.auth().currentUser!.uid
    var selectedProduct : Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        

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
        return searching ? filteredProducts.count : products.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! displayContactTVCell

        let product = searching ? filteredProducts[indexPath.row] : products[indexPath.row]
        
        cell.productName.text = product.name
        cell.productName?.numberOfLines = 0
        cell.productName?.lineBreakMode = .byWordWrapping
        cell.delegate = self
        cell.productPrice.text = "$\(product.price)"
        cell.product = product
        
        if product.stock == 0 {
            cell.stockLabel.text = "Out of order"
            cell.stockLabel.textColor = .red
        } else if product.stock < 20 {
            cell.stockLabel.text = "Low stock"
            cell.stockLabel.textColor = .orange
        } else {
            cell.stockLabel.text = "In stock"
            cell.stockLabel.textColor = .green
        }
        cell.layer.cornerRadius = 8.0
        
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
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text: \(searchText)")
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedText.isEmpty {
            searching = true
            filteredProducts = products.filter {
                $0.name.lowercased().contains(trimmedText.lowercased())
            }
            print("Found \(filteredProducts.count) matches")
        } else {
            searching = false
            filteredProducts.removeAll()
        }
        
        print("Searching: \(searching)")
        displayContactTVC.reloadData()
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
