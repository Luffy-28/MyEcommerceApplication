//
//  displayContactTVCell.swift
//  ecommerceApplication
//
//  Created by shankar singh on 11/04/2025.
//

import UIKit

protocol ProductActionDelegate: AnyObject {
    func didTapAddToCart(product: Product)
    func didTapAddToWishlist(product: Product)
}

class displayContactTVCell: UITableViewCell {

    @IBOutlet weak var stockLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    weak var delegate: ProductActionDelegate?
    var product: Product!
    @IBAction func addtoWishlist(_ sender: Any) {
        if let product = product {
            delegate?.didTapAddToWishlist(product: product)
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
       if let product = product {
            delegate?.didTapAddToCart(product: product)
        }
    }
    

    
    
}
