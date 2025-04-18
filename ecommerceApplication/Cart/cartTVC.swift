import UIKit
import FirebaseAuth

class cartTVC: UITableViewController {
    var service = Repository()
    var products = [Product]()
    let authUserId = Auth.auth().currentUser!.uid

    @IBOutlet var cartTVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        service.fetchCart(for: authUserId) { returnedCart in
            self.products = returnedCart
            self.cartTVC.reloadData()
            self.setupFooter()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? products.count : 1
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 16 : 0
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! cartTVCell
            let product = products[indexPath.row]
            
            cell.nameLabel.text = product.name
            cell.priiceLabel.text = "$\(product.price)"
            if !product.Image.isEmpty, let image = UIImage(named: product.Image) {
                cell.photoImageView.image = image
            } else {
                cell.photoImageView.image = UIImage(systemName: "person.circle.fill")
            }
            cell.photoImageView.layer.cornerRadius = cell.photoImageView.frame.size.width / 2
            cell.photoImageView.clipsToBounds = true
            
            cell.configure(with: product)
            
            cell.onQuantityChange = { [weak self] newQty in
                guard let self = self else { return }

                // Update local data
                self.products[indexPath.row].quantity = newQty

                // Save updated quantity to Firestore
                self.service.updateCartQuantity(for: self.authUserId, productId: product.id, newQuantity: newQty) { success in
                    if success {
                        print("Quantity updated for \(product.name): \(newQty)")
                    } else {
                        print("Failed to update quantity for \(product.name)")
                    }
                }

                self.cartTVC.reloadSections(IndexSet(integer: 1), with: .none)
            }

            
            cell.onRequestDelete = { [weak self] in
                guard let self = self else { return }
                self.deleteConfirmationMessage(
                    title: "Remove Item",
                    message: "Do you want to remove \(product.name) from the cart?",
                    delete: {
                        self.service.deleteFromCart(for: self.authUserId, withProductId: product.id) { success in
                            if success {
                                DispatchQueue.main.async {
                                    self.service.fetchCart(for: self.authUserId) { updatedCart in
                                        self.products = updatedCart
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    },
                    cancel: {
                        print("User canceled deletion")
                    }
                )
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalCell", for: indexPath) as! cartTVCell
            let total = products.reduce(0.0) { result, product in
                let price = Double(product.price) ?? 0.0
                return result + (price * Double(product.quantity))
            }
            cell.backgroundColor = .systemBlue
            cell.totalAmountLable.text = "$\(total)"
            cell.totalAmountLable.font = UIFont.boldSystemFont(ofSize: 18)
            return cell
        }
    }

    func setupFooter() {
        if let footerCell = tableView.dequeueReusableCell(withIdentifier: "checkOut") as? cartTVCell {
            footerCell.layoutIfNeeded()
            let footerHeight = footerCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            footerCell.contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: footerHeight.height)
            
            footerCell.checkoutButton.addAction(UIAction { [weak self] _ in
                
                guard let self = self else { return }
                
                if self.products.isEmpty {
                    self.showToast("Your cart is empty! add some items to checkout")
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let checkoutVC = storyboard.instantiateViewController(withIdentifier: "checkOutTVC") as? checkOutTVC {
                        checkoutVC.cartProducts = self.products  // Optional: Pass data
                        self.navigationController?.pushViewController(checkoutVC, animated: true)
                    }
                }
            }, for: .touchUpInside)
            
            tableView.tableFooterView = footerCell.contentView
        }
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 0 {
            let productToRemove = products[indexPath.row]
            deleteConfirmationMessage(
                title: "Delete Item",
                message: "Are you sure you want to remove \(productToRemove.name) from the cart?",
                delete: { [weak self] in
                    self?.service.deleteFromCart(for: self!.authUserId, withProductId: productToRemove.id) { success in
                        if success {
                            DispatchQueue.main.async {
                                self?.service.fetchCart(for: self!.authUserId) { updatedCart in
                                    self?.products = updatedCart
                                    self?.tableView.reloadData()
                                }
                            }
                        }
                    }
                },
                cancel: {
                    print("User canceled deletion")
                }
            )
        }
    }

    
    @IBAction func unwindToCartTVC(_ unwindSegue: UIStoryboardSegue){
        let sourceViewController = unwindSegue.source
    }
}


