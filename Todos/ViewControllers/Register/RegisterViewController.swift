//
//  RegisterViewController.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 30/04/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    let userDefauls = UserDefaultManager.shared
    let indicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        let error = validateFields()
        
        // show error message
        if error != nil {
            showErrorMessage(errorMsg: error!)
        } else {
            
            // create user
            let firstName = firstNameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                
                if error != nil {
                    self?.showErrorMessage(errorMsg: "Error creating user!")
                } else {
                    // store user into firestore
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["first_name": firstName, "last_name": lastName, "user_id": result!.user.uid]) {
                        (error) in
                            
                            if error != nil {
                                self?.showErrorMessage(errorMsg: "Error saving user data!")
                            }
                    }
                    
                    // register successfully
                    self?.goToHome(userId: result!.user.uid)
                    
                }
                
            }
        }
        
    }
    
    func validateFields() -> String? {
        
        if firstNameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill all the fields!"
        }
        
        return nil
    }
    
    func showErrorMessage(errorMsg: String){
        errorMessage.alpha = 1
        errorMessage.text = errorMsg
        indicator.stopAnimating()
    }
    
    func goToHome(userId: String){
        
        saveUserDefaults(userId: userId)
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
        
        indicator.stopAnimating()
        
    }
    
    func saveUserDefaults(userId: String){
        userDefauls.saveUserLoggedIn(loggedIn: true)
        userDefauls.saveUserId(userId: userId)
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
