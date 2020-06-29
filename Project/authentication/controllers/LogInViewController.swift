//
//  LogInViewController.swift
//  Project
//
//  Created by raz cohen on 11/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import SwiftUI
import SkyFloatingLabelTextField
import SystemConfiguration



class LogInViewController: UIViewController {
    
    //MARK: variables
    
    var emailTextField = SkyFloatingLabelTextFieldWithIcon()
    var passwordTextField = SkyFloatingLabelTextFieldWithIcon()
    static var userID = String()
    
    //MARK: autlets:
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    //MARK: actions:
    
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        
    }
    
    @IBAction func toSignUp(_ sender: UIButton) {
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    
    @IBAction func logInBtn(_ sender: UIButton) {
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        if !CheckInternet().isConnected(with: flags){
            
            PKHUD.sharedHUD.hide()
            
            let alert = UIAlertController(title: "Offline Mode",
                                          message: "This task requires an Internet connection. Please connect to the network if you wish to use it",
                                          preferredStyle: .alert)
            
            alert.addAction(.init(title: "Settings", style: .default, handler: {(action) in
                
                if let url = URL.init(string: UIApplication.openSettingsURLString){
                    
                    UIApplication.shared.open(url,options: [:], completionHandler: nil)
                    
                }
            }))
            
            alert.addAction(.init(title: "Close", style: .destructive, handler: { (action) in}))
            
            self.present(alert, animated: true)
            
        }else{
        
        showProgress(title: "Loged In")
        // check the textFields are valid
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //sign in the user if it exist
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if error != nil{
                
                self?.showError(title:"Log In Failed",subtitle: "Password or Email not correct")
                
            }else{
                
                guard let uid = Auth.auth().currentUser?.uid else{return}
                
                LogInViewController.userID = uid
                
                var users = CoreDatabase.shared.fetchUser()
                
                    if !(self?.userIsSavedInCoreData(userId: uid, users: users))!{
                       
                    self?.getCurrencyFromFirebase {(currency) in
                      
                        let u = User(id: uid, userCurrency: currency,darkMode: false)
                        users.append(u)
                        CoreDatabase.shared.saveContext()
                    }
                        
                }
            
                Rauter.shared.chooseMainViewController()
            }
          }
       }
    }
    
    func userIsSavedInCoreData(userId:String,users:[User])->Bool{
        if users.count > 0{
        for u in users{
            if u.id == userId{
                return true
            }
          }
        }
        return false
    }
    
    func getCurrencyFromFirebase(callback:@escaping(String)->Void){
        
        guard let userId = Auth.auth().currentUser?.uid else{return}

        Database.database().reference().child("users").child(userId).observeSingleEvent(of: .value) {(snapshot) in
            
            let userCurr = snapshot.value as? NSDictionary
            let currency = userCurr?["currency"] as? String ?? ""
            
            DispatchQueue.main.async {
                callback(currency)
            }
        }
    }
    
    @objc func dismissKeyboard() {
          
          view.endEditing(true)
      }
    
    func textFields(){
        
        emailTextField.becomeFirstResponder()
        
        emailTextField = textFieldsUI(text: "Email Address", title: "Enter your email address", imageSystemName: "envelope", position: CGRect(x: 110, y: 340, width: 220, height: 45),passwordType: false , view: self.view)
        
        passwordTextField = textFieldsUI(text: "Password", title: "Enter your password", imageSystemName: "lock", position: CGRect(x: 110, y: 400, width: 220, height: 45),passwordType: true, view: self.view)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        textFields()
        
        makeCircle(button: logInBtn, number: 2)
        makeCircle(button: registerBtn, number: 2)
        logInBtn.setGradientBackgroundFromTwoColors(colorOne: #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1))
        registerBtn.setGradientBackgroundFromTwoColors(colorOne: #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1))
    }
}

extension UIViewController:ShowHUDMessage{}
extension FirebaseExpense:ShowHUDMessage{}
extension LogInViewController:Disign{}
extension LogInViewController:CustomeTextField{}
