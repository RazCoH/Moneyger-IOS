//
//  TexFieldsSignUpViewController.swift
//  Project
//
//  Created by raz cohen on 09/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField
import SystemConfiguration
import PKHUD

class TexFieldsSignUpViewController: UIViewController,UITextFieldDelegate {

    //MARK: variables
    
    var emailTextFiled = SkyFloatingLabelTextFieldWithIcon()
    var passwordTextField = SkyFloatingLabelTextFieldWithIcon()
    var currencyTextField = SkyFloatingLabelTextFieldWithIcon()
    var userNameTextField = SkyFloatingLabelTextFieldWithIcon()
    
    
    var ref: DatabaseReference!
    var isOpen = false
    var currencies = ["AED", "ARS", "AUD", "BGN", "BRL", "BSD", "CAD", "CHF", "CLP", "CNY", "COP", "CZK", "DKK", "DOP", "EGP", "EUR", "FJD", "GBP", "GTQ", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "ISK", "JPY", "KRW", "KZT", "MXN", "MYR", "NOK", "NZD", "PAB", "PEN", "PHP", "PKR", "PLN", "PYG", "RON", "RUB", "SAR", "SEK", "SGD", "THB", "TRY", "TWD", "UAH", "USD", "UYU", "ZAR"]
    
    
    //MARK: outlets
    
      @IBOutlet weak var continueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dissmis the keyboard with tap
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
 
        makeCircle(button: continueBtn, number: 2)
        
        continueBtn.setGradientBackgroundFromTwoColors(colorOne: #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1))
        
        textFields()
    }
    
    // MARK: functions
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        // check if the field are valid
        let error = validateFields()
        if error != nil{
            // something was wrong
            let alert = showAlert(title: "Oooops!", message: error!)
            present(alert, animated: true)
            return
        }else{
            
            self.showProgress()
            
            guard let email = emailTextFiled.text else{return}
            guard let password = passwordTextField.text else{return}
            guard let userName = userNameTextField.text else{return}
            
            Auth.auth().createUser(withEmail: email, password: password) {
                [weak self] (result, err) in
                
                //check for errors:
                
                let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(reachability!, &flags)
            
               if err != nil{
                
                    
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
                        
                        self?.present(alert, animated: true)
                        
                    }else{
                        
                    print(err?.localizedDescription as Any)
                    self?.showError(title: "Can't create user")
                }
                    
                    
                }else{
                
                    // user was created successfully, now store the data in firebase:
                
                    self?.ref = Database.database().reference()
                    let uid:String = Auth.auth().currentUser!.uid
                    self?.ref.child("users")
                        .child(uid)
                        .setValue([
                            "userName": userName,
                            "currency":self?.currencyTextField.text
                        ])
                   
                    var users = CoreDatabase.shared.fetchUser()
                    let chosenCurrency = self?.currencyTextField.text
                    let u = User(id: uid, userCurrency: chosenCurrency!,darkMode: false)
                    users.append(u)
                    CoreDatabase.shared.saveContext()
                     Rauter.shared.chooseMainViewController()
                }
            }
        }
    }
    
    func validateFields()->String?{
        guard let chosenCurr = currencyTextField.text else{return nil}
        
        //check that all the field are fill in:
        
        if  userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            
            emailTextFiled.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            
            currencyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill in all the fields"
            
        }else if !isCurrExist(chosenCurr: chosenCurr){
            
            return "You have selected a currency that does not exist or is   not in the database, please select another currency"
            
        }else if !validName(userNameTextField.text ?? "") ||
                 !validCurr(currencyTextField.text ?? ""){
            
           return "One or more fields are incorrect"
        }
         return nil
    }
    
    func validEmail(_ email:String)->Bool{
         let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
         return emailTest.evaluate(with: email)
     }
     
     func validName(_ name:String)->Bool{
         let nameTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z]{2,}\\s[a-zA-z]{1,}'?-?[a-zA-Z]{2,}\\s?([a-zA-Z]{1,})?)")
         return nameTest.evaluate(with: name)
     }
     
     func validCurr(_ name:String)->Bool{
         let nameTest = NSPredicate(format: "SELF MATCHES %@", "^([A-Z]{3,3}?)")
         return nameTest.evaluate(with: name)
     }
     
     func validPassword(_ password: String)->Bool{
         let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
         return passwordTest.evaluate(with: password)
     }
    
    
    
    func textFields(){
        
   userNameTextField.becomeFirstResponder()
      
        var ySize = Int()
        
        let device =  UIDevice().name
         
         switch device {
             
         case "iPhone 8","iPhone 7","iPhone 6s":
            ySize = 48
         default:
            ySize = 62
         }
        
       userNameTextField = textFieldsUI(text: "First & Last Name", title: "Nice Name", imageSystemName: "person", position: CGRect(x: 0, y: 0, width: 240, height: 45), passwordType: false, view: self.view)
        userNameTextField.autocorrectionType = .no
      
      emailTextFiled = textFieldsUI(text: "Email Address", title: "valid email", imageSystemName: "envelope", position: CGRect(x: 0, y: ySize, width: 240, height: 45), passwordType: false, view: self.view)
        emailTextFiled.autocorrectionType = .no
      
      passwordTextField = textFieldsUI(text: "Password", title: "valid password", imageSystemName: "lock", position: CGRect(x: 0, y: ySize * 2, width: 240, height: 45), passwordType: true, view: self.view)
        passwordTextField.autocorrectionType = .no
      
      currencyTextField = textFieldsUI(text: "Currency Code (USD)", title: "valid currency code", imageSystemName: "dollarsign.circle", position: CGRect(x: 0, y: ySize * 3, width: 240, height: 45), passwordType: false, view: self.view)
      currencyTextField.autocorrectionType = .no
      
      
      emailTextFiled.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
      
      passwordTextField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
      
      currencyTextField.addTarget(self, action: #selector(currencyDidChanged(_:)), for: .editingChanged)
      
      userNameTextField.addTarget(self, action: #selector(userNameDidChanged(_:)), for: .editingChanged)
        

        
    }
    
    @objc func userNameDidChanged(_ textfield: UITextField) {
        if let fullName = textfield as? SkyFloatingLabelTextField{
            if !validName(textfield.text ?? ""){
                fullName.errorMessage = "invalid name"
            }else{
                fullName.errorMessage = ""
            }
        }
    }
    
    @objc func currencyDidChanged(_ textfield: UITextField) {
        if let curr = textfield as? SkyFloatingLabelTextField{
            if !validCurr(textfield.text ?? ""){
                curr.errorMessage = "three cpital letters"
            }else{
                curr.errorMessage = ""
            }
        }
    }
    
    @objc func emailDidChange(_ textfield: UITextField) {
        if let firstEmail = textfield as? SkyFloatingLabelTextField{
            if !validEmail(textfield.text ?? ""){
                firstEmail.errorMessage = "don't forget '@' & '.com'"
            }else{
                firstEmail.errorMessage = ""
            }
        }
    }
    
    @objc func passwordDidChange(_ textfield: UITextField) {
        if let password = textfield as? SkyFloatingLabelTextField{
            if !validPassword(textfield.text ?? ""){
                password.errorMessage = "At least 8 tabs, letters & numbers"
            }else{
                password.errorMessage = ""
            }
        }
    }

    func isCurrExist(chosenCurr:String)->Bool{
        for curr in currencies{
            if curr == chosenCurr{
                return true
            }
        }
        return false
    }


}

extension TexFieldsSignUpViewController:CustomeTextField{}
extension TexFieldsSignUpViewController:Alert{}
extension TexFieldsSignUpViewController:Disign{}
 
