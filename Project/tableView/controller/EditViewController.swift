//
//  EditViewController.swift
//  Project
//
//  Created by raz cohen on 04/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import SystemConfiguration

var isItExpensesGroup:Bool = false

class EditViewController: UIViewController {
    
    //MARK:variables
    
    var amountNumber = ""
    var action = Action()
    var chosenCategory = String()
    var chosenDate = String()
    var url = String()
    var originalDate = String()
    var originalAmount = String()
    var labels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        guard let icon = dleteOutlet.imageView?.image else{return}
        let resizedIcon = icon.resized(with: CGSize(width: 36, height: 26)).withTintColor(#colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1))
        dleteOutlet.setImage(resizedIcon, for: .normal)
        
        labels = [categoryLabel,dateLabel,amountLabel]
       
                if isItDarkMode(){
                    detailTextField.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
                    detailTextField.text = "Enter new detail"
                    detailTextField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
 
         setDarkMode(view: self.view, labels: labels)
        
        let outletsArr = [oneBtn,towBtn,three,fourBtn,fiveBtn,sixBtn,sevenBtn,eightBtn,nineBtn,dotBtn,zeroBtn,dleteOutlet]
        
        for outlet in outletsArr{
            makeCircle(button: outlet!, number: 4)
        }
        
        categoryLabel.text = action.category
        let date = action.date
        dateLabel.text = Dates().castToString(date: date)
        originalDate = Dates().castToString(date: date)
        detailTextField.text = action.detail
        let amountformatted = ActionDataSource.shared.currencyFormat(amount: action.amount)
        amountLabel.text = amountformatted
        originalAmount = amountformatted
        url = action.imageUrl ?? ""
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1)
        if action.imageUrl == nil{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if action.isItExpense{
            isItExpensesGroup = true
        }else{
            isItExpensesGroup = false
        }
    }
    
    //MARK: outlets
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var towBtn: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var dotBtn: UIButton!
    @IBOutlet weak var dleteOutlet: UIButton!
    @IBOutlet weak var photoNI: UIBarButtonItem!
    
    //MARK: actions
    
    @objc func dismissKeyboard() {
             
             view.endEditing(true)
     }
    
    @IBAction func showImage(_ sender: UIBarButtonItem) {
        
        let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        if CheckInternet().isConnected(with: flags){
         
        performSegue(withIdentifier: "toImage", sender: nil)
            
        }else{
            
            let alert = UIAlertController(title: "Offline Mode",
                                          message: "This task requires an Internet connection. Please connect to the network if you wish to use it",
                                          preferredStyle: .alert)
            
            alert.addAction(.init(title: "Settings", style: .default, handler: {(action) in
                
                if let url = URL.init(string: UIApplication.openSettingsURLString){
                    
                    UIApplication.shared.open(url,options: [:], completionHandler: nil)
                    
                }
            }))
            
            alert.addAction(.init(title: "Close", style: .destructive, handler: { (action) in}))
            
            present(alert, animated: true)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? StorageImageViewController else{return}
        dest.url = url
    }
    
    @IBAction func numberBtn(_ sender: UIButton) {
        if amountNumber.count <= 10{
            amountNumber += "\(sender.tag)"
            amountLabel.text = amountNumber
        }
    }
    
    
    @IBAction func dotBtn(_ sender: UIButton) {
        if amountNumber.count <= 10,amountNumber.last != "." {
            amountNumber += "."
            amountLabel.text = amountNumber
        }
    }
    
    
    @IBAction func deleteNumbrtBtn(_ sender: UIButton) {
        var array = amountNumber.map {String($0)}
        if !array.isEmpty{
            array.removeLast()
        }
        amountNumber = ""
        for i in 0..<array.count{amountNumber += array[i]}
        if amountNumber != ""{
            amountLabel.text = amountNumber
        }else{
            amountLabel.text = "0"
        }
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        guard let category = categoryLabel.text , let date = dateLabel.text,
            let detail = detailTextField.text, var amount = amountLabel.text else{
                return
        }
        
    
        let alert = UIAlertController(title: "Oooops!",
                                      message: "You entered invalid amount, please try again",
                                      preferredStyle: .alert)
        
        alert.addAction(.init(title: "Close", style: .destructive, handler: { (action) in}))
        
        if  amount.first != "0" && amount.first != "." {
            
            if originalAmount != amount{

                action.amount = Double(amount)!
            }
            
            action.category = category
            action.detail = detail
            
            print(originalDate,date)
            
            if originalDate != date{
                let newDate = Dates().castToDate(string: date)
                print(newDate)
                CoreDatabase.shared.context.delete(action)
                
                var actions = CoreDatabase.shared.fetchAction()
                actions.append(Action(amount: Double(amount)!, category: category, detail: detail, date: newDate, userID: action.userID, imageUrl: action.imageUrl, isItExpense: action.isItExpense))
            }
             
            CoreDatabase.shared.saveContext()
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func editCategory(_ sender: UIButton) {
        //show category Pop up
         
        let sb = UIStoryboard(name: "CategoryPopUp", bundle: .main)
        guard let vc = sb.instantiateViewController(identifier: "categorySB") as? CategoryPopUpViewController else{return}
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true)
        
        // get the chosen currency from the NotificationCenter in the pop up:
        NotificationCenter.default.addObserver(forName: .saveCategory, object: nil, queue: .main) { [weak self](notification) in
            if let chosenCategory = notification.userInfo?["category"]as? String{
                self?.chosenCategory = chosenCategory
                self?.categoryLabel.text = chosenCategory
            }
        }
    }
    
    
    @IBAction func editDate(_ sender: UIButton) {
        //show date Pop up:
        let sb = UIStoryboard(name: "DatePopUp", bundle: .main)
        guard let vc = sb.instantiateViewController(identifier: "DatePickerSB") as? DatePickerDialogViewController else{return}
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true)
        
        NotificationCenter.default.addObserver(forName: .saveDate, object: nil, queue: .main) { [weak self](notification) in
            if let chosenDate = notification.userInfo?["date"]as? String{
                self?.chosenDate = chosenDate
                self?.dateLabel.text = chosenDate
            }
        }
    }
}

extension EditViewController:Disign{}
extension EditViewController:ScreenMode{}

