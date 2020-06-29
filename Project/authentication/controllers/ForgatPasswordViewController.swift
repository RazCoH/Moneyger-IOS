//
//  ForgatPasswordViewController.swift
//  Project
//
//  Created by raz cohen on 05/06/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase

class ForgatPasswordViewController: UIViewController {

    @IBOutlet weak var sendBtn: UIButton!
    
    //MARK: variables
    
    var emailTextField = SkyFloatingLabelTextFieldWithIcon()
    
    //MARK: actions & functions
    
    
    @IBAction func send(_ sender: UIButton) {
        
        let auth = Auth.auth()
        
 
        auth.sendPasswordReset(withEmail: emailTextField.text!) {[weak self] (error) in
            if error != nil {
                
                self?.showError(title: "Error",subtitle: "Can't send new password to this email")
                return
                
            }else{
               
                self?.showSucsses(title: "Send!")
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        
    }
    
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendBtn.isEnabled = false
            
        emailTextField.becomeFirstResponder()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        emailTextField = textFieldsUI(text: "Email Address", title: "Enter your email address", imageSystemName: "envelope", position: CGRect(x: 32, y: 80, width: 280, height: 45),passwordType: false , view: self.view)
        
        emailTextField.autocorrectionType = .no
        
        emailTextField.addTarget(self, action: #selector(emailDidChange(_:)), for: .editingChanged)
        
         makeCircle(button: sendBtn, number: 2)
         sendBtn.setGradientBackgroundFromTwoColors(colorOne: #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1))
    }
    
    func validEmail(_ email:String)->Bool{
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
        return emailTest.evaluate(with: email)
    }
    
    @objc func emailDidChange(_ textfield: UITextField) {
          if let firstEmail = textfield as? SkyFloatingLabelTextField{
              if !validEmail(textfield.text ?? ""){
                  firstEmail.errorMessage = "don't forget '@' & '.com'"
                  sendBtn.isEnabled = false
                
              }else{
                
                  firstEmail.errorMessage = ""
                  sendBtn.isEnabled = true
              }
          }
      }
}

extension ForgatPasswordViewController:CustomeTextField{}
extension ForgatPasswordViewController:Disign{}
