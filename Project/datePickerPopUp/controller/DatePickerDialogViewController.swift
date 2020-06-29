//
//  DatePickerDialogViewController.swift
//  Project
//
//  Created by raz cohen on 19/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import FirebaseAuth

class DatePickerDialogViewController: UIViewController , UIPickerViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registerDate = Auth.auth().currentUser?.metadata.creationDate
        datePicker.minimumDate = registerDate
        makeCircle(button: confimBtn, number: 2)
        setDarkMode(view: myView, labels: nil)
        
        confimBtn.setGradientBackgroundFromTwoColors(colorOne: #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1))
        
        if isItDarkMode(){
          datePicker.setValue(#colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1), forKeyPath: "textColor")
        }else{
          datePicker.setValue(#colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1), forKeyPath: "textColor")
        }
        
        datePicker.setValue(false, forKey: "highlightsToday")
        datePicker.subviews[0].subviews[1].backgroundColor = #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1)
        datePicker.subviews[0].subviews[2].backgroundColor = #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1)
        
        myView.layer.masksToBounds = true
        myView.layer.cornerRadius = (myView.frame.height) / 14
        
        //TODO: maximum date?
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDarkMode(view: myView, labels: nil)
        if isItDarkMode(){
          datePicker.setValue(#colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1), forKeyPath: "textColor")
        }else{
          datePicker.setValue(#colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1), forKeyPath: "textColor")
        }
    }
    //MARK: outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confimBtn: UIButton!
    @IBOutlet weak var myView: UIView!
    
    //MARK: actions
    
    @IBAction func confirm(_ sender: UIButton) {
        let date = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, y"
        let dateInFormat = dateFormatter.string(from: date)
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.post(name: .saveDate, object: nil, userInfo: ["date":dateInFormat])
        
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
         dismiss(animated: true)
    }
}

extension DatePickerDialogViewController:Disign{}
extension DatePickerDialogViewController:PickerLabel{}
extension DatePickerDialogViewController:ScreenMode{}
