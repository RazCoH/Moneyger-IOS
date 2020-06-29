//
//  KeyBoardViewController.swift
//  Project
//
//  Created by raz cohen on 10/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SystemConfiguration

protocol RateDelegate{
    func getRate(rate:Double)
}

class KeyBoardViewController: UIViewController{
    
    // MARK: variables
    
    var amountNumber = ""
    var category = ""
    var color = UIColor()
    var icon = UIImage()
    var customeDateTapped:Bool = false
    var customeDatePicked:Bool = false
    var customeDate = String()
    let picker = UIImagePickerController()
    var chosenImage = UIImage()
    var placeHolderImage = UIImage()
    let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    var flags = SCNetworkReachabilityFlags()
    var realAmountOfConvertion = Double()
    var convertionPicked:Bool = false
    
    // MARK: outlets
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var convertBtnOT: UIButton!
    @IBOutlet weak var checkMarkBtnOT: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconImageButton: UIButton!
    @IBOutlet weak var addBtn: UIButton!
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
    @IBOutlet weak var customeDateOutlet: UIButton!
    @IBOutlet weak var backArrow: UIButton!
    @IBOutlet weak var subView: UIView!
    
    // MARK: actions
    
    @IBAction func numberBtn(_ sender: UIButton) {
        if amountNumber.count <= 10{
            amountNumber += "\(sender.tag)"
            amountLabel.text = amountNumber
        }
        
        convertBtnOT.isEnabled = true
        checkMarkBtnOT.isEnabled = true
    }
    
    @IBAction func dotBtn(_ sender: UIButton) {
        if amountNumber.count <= 10,amountNumber.last != "." {
            amountNumber += "."
            amountLabel.text = amountNumber
        }
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
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
    
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {

        SCNetworkReachabilityGetFlags(reachability!, &flags)
        if CheckInternet().isConnected(with: flags){
            
        picker.delegate = self
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        present(picker, animated: true)
            
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
 
    //convertion for another curroncy
    @IBAction func exchangeBtn(_ sender: UIButton) {
        
        //chaeck internet connection:
       
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        if CheckInternet().isConnected(with: flags){
            //there is connection
            
            //show the pop up after clicked:
            let sb = UIStoryboard(name: "ExchangePopUp", bundle: .main)
            
            guard let vc = sb.instantiateViewController(identifier: "exchange") as? ExchangePopUpViewController else{return}
        
            vc.modalPresentationStyle = .overCurrentContext
        
            present(vc, animated: true)
            
            vc.delegate = self
            
            
        }else{
            // no internet

            //show alert:

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
    
   
    
    // change the date
    
    @IBAction func customeBtn(_ sender: UIButton) {
        let sb = UIStoryboard(name: "DatePopUp", bundle: .main)
        guard let vc = sb.instantiateViewController(identifier: "DatePickerSB") as? DatePickerDialogViewController else{return}
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true)
        
        NotificationCenter.default.addObserver(forName: .saveDate, object: nil, queue: .main) { (notification) in
            if let customeDate = notification.userInfo?["date"]as? String{
                self.customeDate = customeDate
            }
        }
        customeDatePicked = true
    }
    
    
    // save action
    @IBAction func checkMarkBtn(_ sender: UIButton) {
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        var date = ""
        var amount = Double()
        let fbExpense = FirebaseExpense(id: uid)
        let alert = UIAlertController(title: "Oooops!",
                                      message: "You entered invalid amount, please try again",
                                      preferredStyle: .alert)
        
        alert.addAction(.init(title: "Close", style: .destructive, handler: { (action) in}))
        
        let detail = detailTextField.text
        let amountString = amountLabel.text
        
        if  amountString?.first != "0" && amountString?.first != "." {
            
            if convertionPicked{
                
                amount = realAmountOfConvertion
                
            }else{
                
                amount = Double(amountString!)!
            }
            
            if !customeDatePicked{
                date = Dates().getCurrentDate()
            }else{
                date = customeDate
            }
            
            if category.elementsEqual("Salary") || category.elementsEqual("Gifts") || category.elementsEqual("Investments") || category.elementsEqual("Global")  {
                
                //its profit:
                var actions = CoreDatabase.shared.fetchAction()
                let dateType = Dates().castToDate(string: date)
                func afterSave(_ error:Error?, _ success:Bool){
                    if success{
                        showSucsses(title: "Image Saved")
                        print("Image Saved !!!")
                        let p = Action(amount: amount, category: category, detail: detail ?? "", date: dateType, userID: uid , imageUrl: fbExpense.imageURL!, isItExpense: false)
                        actions.append(p)
                        CoreDatabase.shared.saveContext()
                        navigationController?.popToRootViewController(animated: true)
                    }else{
                        print("Saved Faild !!!")
                        showError(title: "Please try again", subtitle: error?.localizedDescription)
                        return
                    }
                }
                
                guard let image = imageView.image else{return}
                if image != placeHolderImage{
                    showProgress()
                    fbExpense.saveImage(image: image, callback: afterSave(_:_:))
                    
                }else{
                    
                    let p = Action(amount: amount, category: category, detail: detail ?? "", date: dateType, userID: uid , isItExpense: false)
                    actions.append(p)
                    CoreDatabase.shared.saveContext()
                    navigationController?.popToRootViewController(animated: true)
                }
                
            }else{
                
                //its expense:
                var actions = CoreDatabase.shared.fetchAction()
                let dateType = Dates().castToDate(string: date)
                
                func afterSave(_ error:Error?, _ success:Bool){
                    if success{
                        showSucsses(title: "Image Saved")
                        print("Image Saved !!!")
                        let e = Action(amount: amount, category: category, detail: detail ?? "", date: dateType, userID: uid, imageUrl: fbExpense.imageURL!,isItExpense: true)
                        actions.append(e)
                        CoreDatabase.shared.saveContext()
                        navigationController?.popToRootViewController(animated: true)
                    }else{
                        print("Saved Faild !!!")
                        showError(title: "Please try again", subtitle: error?.localizedDescription)
                        return
                    }
                }
                
                guard let image = imageView.image else{return}
                if image != placeHolderImage {
                    showProgress()
                    
                    print("in proggress...!!")
                    
                    fbExpense.saveImage(image: image, callback: afterSave(_:_:))
                    
                }else{
                    let e = Action(amount: amount, category: category, detail: detail ?? "", date: dateType, userID: uid, isItExpense: true)
                    actions.append(e)
                    CoreDatabase.shared.saveContext()
                    navigationController?.popToRootViewController(animated: true)
                }
            }
        }else{
            present(alert, animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
            
            view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sb = UIStoryboard(name: "ExchangePopUp", bundle: .main)
        
        guard let vc = sb.instantiateViewController(identifier: "exchange") as? ExchangePopUpViewController else{return}
        
        vc.delegate = self
        
        setDarkMode(view: subView, labels: [amountLabel])
        
        if isItDarkMode(){
            
            detailTextField.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
            detailTextField.placeholder = "Add details (optional)"
            
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        placeHolderImage = imageView.image!
        iconImageButton.tintColor = .white
        let resizedIcon = icon.resized(with: CGSize(width: 40, height: 36)).withTintColor(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 1, alpha: 1))
        iconImageButton.setImage(resizedIcon, for: .normal)
        iconImageButton.backgroundColor = color
        iconImageButton.layer.masksToBounds = true
        iconImageButton.layer.cornerRadius = (iconImageButton.frame.height) / 2
        categoryLabel.text = category 
        convertBtnOT.isEnabled = false
        checkMarkBtnOT.isEnabled = false
        let outletsArr = [dleteOutlet,checkMarkBtnOT,oneBtn,towBtn,three,fourBtn,fiveBtn,sixBtn,sevenBtn,eightBtn,nineBtn,zeroBtn,dotBtn,addBtn,convertBtnOT,customeDateOutlet]
        
        guard let arrow = backArrow.currentImage else{return}
        let resizedArrow = arrow.resized(with: CGSize(width: 40, height: 32)).withTintColor(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 1, alpha: 1))
        backArrow.setImage(resizedArrow, for: .normal)
        
        let btnsWithImages = [dleteOutlet,checkMarkBtnOT,convertBtnOT,customeDateOutlet]
        
        for outlet in outletsArr{
            makeCircle(button: outlet!, number: 4)
        }
        
        for btn in btnsWithImages{
            guard let icon = btn?.currentImage else{return}
            let image = icon.resized(with: CGSize(width: 40, height: 32)).withTintColor(#colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1))
            btn?.setImage(image, for: .normal)
            
        }
    }
}

extension KeyBoardViewController:Disign{}

extension UIImage{
    func resized(with size:CGSize)->UIImage{
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { [weak self](context) in
            self?.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension KeyBoardViewController:RateDelegate{
    
    func getRate(rate: Double) {
        // calculate the amount with rate from protocol:
        print("Here!!!")
        let amountString = self.amountLabel.text
        let amountDouble = Double(amountString!)
        let amount = (amountDouble ?? 0) * (rate)
        realAmountOfConvertion = amount
        convertionPicked = true
        let amountFormatted = ActionDataSource.shared.currencyFormat(amount: amount)
        self.amountLabel.text = amountFormatted
        
    }
    
    
}

extension KeyBoardViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
        }
    }
}

extension KeyBoardViewController:ScreenMode{}




