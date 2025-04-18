//
//  productDetialTVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 17/04/2025.
//

import UIKit
import FirebaseAuth

class productDetialTVC: UITableViewController {
    var products : Product!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    @IBOutlet weak var checkReviewBUtton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        productNameLabel.text = products.name
        productPriceLabel.text = "AUD $\(products.price)"
        productDescriptionLabel.text = "Description: \(products.description)"
        productDescriptionLabel?.numberOfLines = 0
        productDescriptionLabel?.lineBreakMode = .byWordWrapping
        if !products.Image.isEmpty && UIImage(named: products.Image) != nil{
            photoImageView.image = UIImage(named: products.Image)
        }else{
            photoImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 5
        photoImageView.clipsToBounds = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let ReviewTVC = segue.destination as? ReviewTVC{
            ReviewTVC.products = products
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
