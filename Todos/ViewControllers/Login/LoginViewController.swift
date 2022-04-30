//
//  LoginViewController.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 30/04/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    let userDefauls = UserDefaultManager.shared
    let indicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserLoggedIn()

    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.startAnimating()
        
        let error = validateFields()
        
        // show error message
        if error != nil {
            showErrorMessage(errorMsg: error!)
        } else {
            
            // login
            let email = emailInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                
                if error != nil {
                    self?.showErrorMessage(errorMsg: "Wrong email or password!")
                } else {
                    
                    // login successfully
                    self?.goToHome()
                }
            }
        }
        
    }
    
    func validateFields() -> String? {
        
        if emailInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "You need to provide email and password!"
        }
        
        return nil
    }
    
    func showErrorMessage(errorMsg: String){
        errorMessage.alpha = 1
        errorMessage.text = errorMsg
        indicator.stopAnimating()
    }
    
    func goToHome(){
        
        saveUserDefaults()
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as! HomeViewController
        self.navigationController?.pushViewController(homeVC, animated: true)
        
        indicator.stopAnimating()
        
    }
    
    func saveUserDefaults(){
        userDefauls.saveUserLoggedIn(loggedIn: true)
    }
    
    func checkIfUserLoggedIn(){
        let isLoggedIn = userDefauls.getIfUserLoggedIn()
        
        if isLoggedIn {
            goToHome()
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
