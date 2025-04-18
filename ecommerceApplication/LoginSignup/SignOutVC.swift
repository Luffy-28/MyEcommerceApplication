//
//  SignOutVC.swift
//  ecommerceApplication
//
//  Created by shankar singh on 29/03/2025.
//

import UIKit
import FirebaseAuth

class SignOutVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var service = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        guard !emailTextField.text.isBlank else{
            return showAlertMessage(tittle: "Error", message: "Email is required")
        }
        guard !passwordTextField.text.isBlank else{
            return showAlertMessage(tittle: "Alert", message: "Password is required")
            
        }
        
        guard passwordTextField.text == confirmPasswordTextField.text else{
            return showAlertMessage(tittle: "Alert", message: "Password doesnot match")
        }
        
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
            
                password == confirmPassword else {
            return showAlertMessage(tittle: "Alert", message: "Password doesnot match")
        }
        
      //  create a closure
        let registerClosure: () -> Void = {
            //block of code
            var userAuthId = Auth.auth().currentUser?.uid
            //register a user with it's id in firestore
            let user = User(id: userAuthId!,
                            name: "",
                            email: email,
                            phone: "",
                            address: "",
                            photo: ""
                        )
        //save the object user into the database
            
            if self.service.addUser(withData: user){
                print("User Added: \(user.email)")
            }
            //remove the visiable (signup VC) view controller from the backstack(making login VC Visiabl
            self.navigationController?.popViewController(animated: true)
        }
        // all the info is ready to use
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                self.showAlertMessage(tittle: "We could not create a account", message: "\(error!.localizedDescription)")
                return
            }
            print(authResult?.user.uid)
            
            /**
             Email Confirmation
             */
            Auth.auth().currentUser?.sendEmailVerification(){ error in
                if let error = error {
                    //there is an error
                    self.showAlertMessage(tittle: "Error", message: "\(error.localizedDescription)")
                    return
                }
                
                //here there was no error
                self.showAlertMessageHandler(tittle: "Email Confirmation sent", message: "A confirmation email has been sent to your account, please confirm your account before you log in", onComplete: registerClosure)
                
            }
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
