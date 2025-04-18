//
//  ReviewTVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 17/04/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ReviewTVC: UITableViewController {
    
    @IBOutlet var ReviewTVC: UITableView!
    let service = Repository()
    var products : Product!
    var users : User!
    var reviews = [review]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let authUserId = Auth.auth().currentUser?.uid ?? ""
        service.findUserInfo(for: authUserId) { returnUser in
            self.users = returnUser
            self.ReviewTVC.reloadData()
        }
        
        
        service.fetchReviews(for: products.id) { fetchReview in
            self.reviews = fetchReview
            self.ReviewTVC.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reviews.count + 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < reviews.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! ReviewTVCell
            let reviewData = reviews[indexPath.row]
            
            cell.usernameLAbel.text = reviewData.name
            cell.userReview.text = reviewData.comment
            
            cell.userReview.numberOfLines = 0
            cell.userReview.lineBreakMode = .byWordWrapping
            cell.userReview.adjustsFontForContentSizeCategory = true

            cell.reviewSlider.value = Float(reviewData.rating)
            cell.reviewSlider.isUserInteractionEnabled = false
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "postTVCell", for: indexPath) as! ReviewTVCell
            cell.giveReviewSlider.isUserInteractionEnabled = true
            return cell
        }
    }
    @IBAction func postsisTap(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let cell = button.superview?.superview as? ReviewTVCell else { return }
        guard let reviewTxt = cell.txtReview.text, !reviewTxt.isEmpty else {
            print("Review text is empty")
            return
        }
        let alreadyReviewed = reviews.contains { $0.userId == users.id }
        if alreadyReviewed{
            showAlertMessage(tittle:"Review Exist", message:"You’ve already submitted a review for this product." )
            return
        }
        
        let rating = Int(cell.giveReviewSlider.value)
        
        let newReview = review(id: UUID().uuidString,
                               userId:users.id,
                               name: users.name,
                               rating: rating,
                               comment: reviewTxt,
                               timestamp: Timestamp(date: Date())
)
        service.addReview(for: products.id, review: newReview) { success in
            if success {
                self.reviews.insert(newReview, at: 0)
                cell.txtReview.text = ""
                cell.giveReviewSlider.value = 0.0
                self.ReviewTVC.reloadData()
            }
        }
        
    }
    

    @IBAction func caceldidTAp(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        guard let cell = button.superview?.superview as? ReviewTVCell else { return }
        cell.txtReview.text = ""
        cell.giveReviewSlider.value = 0.0
    }
    

}
