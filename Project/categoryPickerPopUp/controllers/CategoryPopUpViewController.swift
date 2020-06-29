//
//  CategoryPopUpViewController.swift
//  Project
//
//  Created by raz cohen on 04/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class CategoryPopUpViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode(view: myView, labels: nil)
        confirmUiBtn.setGradientBackgroundFromTwoColors(colorOne: #colorLiteral(red: 0.5896319747, green: 0.5186154842, blue: 1, alpha: 1), colorTwo: #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1))
        makeCircle(button: confirmUiBtn, number: 2)
        myView.layer.masksToBounds = true
        myView.layer.cornerRadius = (myView.frame.height) / 14
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDarkMode(view: myView, labels: nil)
    }
    
    //MARK: variables
    
    var chosen:String = ""

    let expenses = [Categorys.bills.rawValue,Categorys.shopping.rawValue,
                    Categorys.presents.rawValue,Categorys.health.rawValue,Categorys.leisure.rawValue,
                    Categorys.travel.rawValue,Categorys.transport.rawValue,Categorys.food.rawValue,
                    Categorys.general.rawValue,Categorys.groceries.rawValue]
    
    let profits = [Categorys.salary.rawValue,Categorys.gifts.rawValue,
                   Categorys.investments.rawValue,Categorys.global.rawValue]
    
    
    //MARK:outlets
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var confirmUiBtn: UIButton!
    @IBOutlet weak var myView: UIView!
    
    //MARK: actions
    
    @IBAction func confirmBtn(_ sender: UIButton) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: .saveCategory, object: nil, userInfo: ["category":chosen])
        dismiss(animated: true)
    }
    
    //MARK: functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isItExpensesGroup{
            return expenses.count
        }else{
            return profits.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isItExpensesGroup{
            return expenses[row]
        }else{
            return profits[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isItExpensesGroup{
            let category = expenses[row]
            chosen = category
            
        }else{
            let category = profits[row]
            chosen = category
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if isItExpensesGroup{
            let label = uiLabel(stringArray: expenses, row: row)
            if isItDarkMode(){
                label.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
            }
            
            return label
            
        }else{
            let label = uiLabel(stringArray: profits, row: row)
            if isItDarkMode(){
                label.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
            }
            return label
        }
    }
}

extension CategoryPopUpViewController:PickerLabel{}
extension CategoryPopUpViewController:Disign{}
extension CategoryPopUpViewController:ScreenMode{}

