//
//  UIExtensions.swift
//  Project
//
//  Created by raz cohen on 23/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField
import PKHUD

extension UIView{
    func setGradientBackgroundFromTwoColors(colorOne:UIColor,colorTwo:UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor,colorTwo.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// protocol extention
protocol ShowHUDMessage{}

extension ShowHUDMessage{
    func showProgress(title:String? = nil,subtitle:String? = nil){
        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    
    func showError(title:String? = nil,subtitle:String? = nil){
        HUD.flash(.labeledError(title: title, subtitle: subtitle),delay: 3)
    }
    
    func showSucsses(title:String? = nil,subtitle:String? = nil){
        HUD.flash(.labeledSuccess(title: title, subtitle: subtitle),delay: 2)
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

protocol CustomeTextField{}
extension CustomeTextField{
    
    func textFieldsUI(text:String, title: String, imageSystemName:String , position: CGRect , passwordType:Bool , view: UIView)-> SkyFloatingLabelTextFieldWithIcon{
        let purple = #colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1)
        let textFieldFrame = position
        let textField = SkyFloatingLabelTextFieldWithIcon(frame: textFieldFrame , iconType: .image)
        textField.placeholder = text
        textField.title = title
        textField.selectedTitleColor = purple
        textField.lineColor = purple
        textField.tintColor = purple
        textField.textColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
        
        if passwordType{
            
            textField.isSecureTextEntry = true
            
        }
        
        textField.iconImage = UIImage(systemName: imageSystemName)
        textField.iconColor = purple
        textField.lineHeight = 1.0
        textField.selectedLineColor = purple
        textField.selectedLineHeight = 2.5
        textField.titleFont = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 12)!
        textField.placeholderFont = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 16)!
        textField.selectedIconColor = purple
        textField.errorColor = .red
        view.addSubview(textField)
        return textField
    }
}

protocol Alert{}
extension Alert{
    func showAlert(title:String,message:String)->UIAlertController{
        let alert = UIAlertController(title: title,message: message,preferredStyle: .alert)
        alert.addAction(.init(title: "Close", style: .destructive, handler: { (action) in}))
        return alert
    }
}

protocol Disign{}

extension Disign{
    func makeCircle(button:UIButton,number:CGFloat){
        button.layer.masksToBounds = true
        button.layer.cornerRadius = (button.frame.height) / number
    }
}

protocol PickerLabel{}
extension PickerLabel{
    func uiLabel(stringArray:[String],row:Int) -> UILabel{
        let pickerLabel = UILabel()
        pickerLabel.textColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
        pickerLabel.text = stringArray[row]
        pickerLabel.font = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 24)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
}

protocol GetUserCurrency{}

extension GetUserCurrency{
    
    func getUserCurr()->String{
        var userCurrency = String()
        let users = CoreDatabase.shared.fetchUser()
        for u in users{
            if u.id == HomeViewController.uid{
                userCurrency = u.userCurrency
            }
        }
        return userCurrency
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
}

protocol ScreenMode{}

extension ScreenMode{
    
    func setDarkMode(view:UIView,labels:[UILabel]?){
        let users = CoreDatabase.shared.fetchUser()
        for u in users{
            if u.id == HomeViewController.uid{
                if u.darkMode{
                    view.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3254901961, alpha: 1)
                    if labels != nil{
                        for l in labels!{
                            l.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }
                    }
                }else{
                    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    if labels != nil{
                        for l in labels!{
                            l.textColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
                        }
                    }
                }
            }
        }
    }
    
    func isItDarkMode()->Bool{
        var b:Bool = Bool()
        let users = CoreDatabase.shared.fetchUser()
        for u in users{
            if u.id == HomeViewController.uid{
                if u.darkMode{
                    
                    b = true
                    
                }else{
                    
                    b = false
    
                }
            }
        }
        return b
    }
}








