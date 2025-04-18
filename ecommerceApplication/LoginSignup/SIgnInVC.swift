//
//  SIgnInVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 29/03/2025.
//

import UIKit
import FirebaseAuth

class SIgnInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgetPasswordButton(_ sender: Any) {
        guard !emailTextField.text.isBlank else{
            self.showAlertMessage(tittle: "Email is Empty", message: "Please input your email")
            return
        }
        logInActivityIndicatorView.startAnimating()
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!){ error in
            if let error = error {
                self.showAlertMessage(tittle: "Error", message: "\(error)")
                self.logInActivityIndicatorView.stopAnimating()
                return
            }
            self.logInActivityIndicatorView.stopAnimating()
            self.showAlertMessage(tittle: "Email Confirmation", message: "A confirmation email has been sent to you email account")
          }
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailTextField.text, !email.isBlank  else{
            return showAlertMessage(tittle: "Error", message: "please enter the email")
        }
        guard let password = passwordTextField.text, !password.isBlank  else{
            return showAlertMessage(tittle: "Error", message: "please enter the password")
        }
        
        // we have to firebase to Auth login
        logInActivityIndicatorView.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password){
            authResult, error in
            //complection block
            guard error == nil else{
                self.showAlertMessage(tittle: "Failed to login", message: "\(error!.localizedDescription)")
                return
            }
            //verify email configuration
            guard let authUser = Auth.auth().currentUser,authUser.isEmailVerified else{
                self.showAlertMessage(tittle: "Pending Email verification", message: "We have sent you an email for the verification please follow the instruction")
                self.logInActivityIndicatorView.stopAnimating()
                return
            }
            // at this point user credentials are fine, also the email confirmation has been clicked
            
            //program to navigate to HomeVC
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! UITabBarController
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
            
        }
        
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
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
