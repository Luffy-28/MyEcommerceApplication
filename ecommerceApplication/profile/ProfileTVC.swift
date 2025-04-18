//
//  ProfileTVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 15/04/2025.
//

import UIKit
import FirebaseAuth
import UniformTypeIdentifiers

class ProfileTVC: UITableViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtphoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    let service = Repository()
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userAuthId = Auth.auth().currentUser?.uid
        self.saveButton.isEnabled = false
        service.findUserInfo(for: userAuthId!) { returnedUser in
            self.user = returnedUser
            self.emailLabel.text = self.user.email
            self.txtName.text = self.user.name
            self.txtphoneNumber.text = self.user.phone
            self.txtAddress.text = self.user.address
            self.saveButton.isEnabled = true
        }
    }
    func isDataValid() -> Bool {
        var totalInvalidComponents : Int = 0
        if txtName.text.isBlank {
            txtName.showInvalidBorder()
            totalInvalidComponents = totalInvalidComponents + 1
        }else{
            txtName.removeInvalidBorder()
        }
        
        if txtphoneNumber.text.isBlank {
            txtphoneNumber.showInvalidBorder()
            totalInvalidComponents = totalInvalidComponents + 1
        }else{
            txtphoneNumber.removeInvalidBorder()
        }
        
        if totalInvalidComponents > 0 {
            showAlertMessage(tittle: "Validation", message: "Please input the required information")
            return false
        }else{
            return true
        }
        
    }
    
    
    @IBAction func saveDidPressButton(_ sender: Any) {
        if isDataValid(){
            
            let updatedUser = User(id: user.id,
                                   name: txtName.text ?? "",
                                   email: emailLabel.text ?? "",
                                   phone: txtphoneNumber.text ?? "",
                                   address: txtAddress.text ?? "",
                                   photo: "")
            
            service.updateUser(withData: updatedUser){ success in
                DispatchQueue.main.async {
                    if success{
                        self.showAlert(message: "Profile updated successfully.")
                    } else {
                        self.showAlert(message: "Failed to update profile.")
                    }
                }
            }
        }
    }
        
        @IBAction func logoutDidPressButton(_ sender: Any) {
            showConfirmationAlert(
                title: "Log Out",
                message: "Are you sure you want to logout?",
                okHandler: {
                    do {
                        try Auth.auth().signOut()
                        
                        // Navigate to Login screen (update identifier as needed)
                        if let sceneDelegate = UIApplication.shared.connectedScenes
                            .first?.delegate as? SceneDelegate {
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let SigninVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                            sceneDelegate.window?.rootViewController = SigninVC
                        }
                        
                    } catch {
                        self.showAlert(message: "Logout failed: \(error.localizedDescription)")
                    }
                }
            )
            
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
