//
//  cartTVCell.swift
//  ecommerceApplication
//
//  Created by shankar singh on 12/04/2025.
//

import UIKit

class cartTVCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priiceLabel: UILabel!
    
    @IBOutlet weak var descreseButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var IncreaseLabel: UIButton!
    
    @IBOutlet weak var totalAmountLable: UILabel!
    
    @IBOutlet weak var AddMoreButton: UIButton!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    var onQuantityChange: ((Int) -> Void)?
    var onDeleteTapped: (() -> Void)?
    var onRequestDelete: (() -> Void)?
    private var quantity: Int = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel?.text = "\(quantity)"
    }
    
    @IBAction func didTapMinus(_ sender: Any) {
        if quantity > 1 {
                    quantity -= 1
                    numberLabel.text = "\(quantity)"
                    onQuantityChange?(quantity)
                } else {
                    onRequestDelete?()
                }
    }
    
    @IBAction func didTapPlus(_ sender: Any) {
        quantity += 1
        numberLabel.text = "\(quantity)"
        onQuantityChange?(quantity)
    }
    
    func configure(with product: Product){
        self.quantity = product.quantity
        numberLabel.text = "\(quantity)"
    }
    
    
}
