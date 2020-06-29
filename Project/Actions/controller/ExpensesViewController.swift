//
//  ExpensesViewController.swift
//  Project
//
//  Created by raz cohen on 15/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase




class ExpensesViewController: UIViewController {
    
    //MARK: outlets:
    
    //amounts:
    @IBOutlet weak var totalExpences: UILabel!
    @IBOutlet weak var generalAmount: UILabel!
    @IBOutlet weak var helthAmount: UILabel!
    @IBOutlet weak var foodAmount: UILabel!
    @IBOutlet weak var shopingAmount: UILabel!
    @IBOutlet weak var presentsAmount: UILabel!
    @IBOutlet weak var familyAmount: UILabel!
    @IBOutlet weak var leisureAmount: UILabel!
    @IBOutlet weak var transportationAmount: UILabel!
    @IBOutlet weak var groceriesAmount: UILabel!
    @IBOutlet weak var segmentOT: UISegmentedControl!
    @IBOutlet weak var billsAmount: UILabel!
    @IBOutlet weak var travelAmount: UILabel!
    @IBOutlet weak var sportAmount: UILabel!
    
    
    //icons:
    
    @IBOutlet weak var presentIcon: UIButton!
    @IBOutlet weak var foodIcon: UIButton!
    @IBOutlet weak var shoppingIcon: UIButton!
    @IBOutlet weak var groceriesIcon: UIButton!
    @IBOutlet weak var leisureIcon: UIButton!
    @IBOutlet weak var familyIcon: UIButton!
    @IBOutlet weak var billsIcon: UIButton!
    @IBOutlet weak var transportIcon: UIButton!
    @IBOutlet weak var travelIcon: UIButton!
    @IBOutlet weak var sportIcon: UIButton!
    @IBOutlet weak var generalIcon: UIButton!
    @IBOutlet weak var healthIcon: UIButton!
    
    //MARK: labels
    
    
    
    @IBOutlet weak var groceriesName: UILabel!
    @IBOutlet weak var shoppingName: UILabel!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var billsName: UILabel!
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var healthName: UILabel!
    @IBOutlet weak var leisureName: UILabel!
    @IBOutlet weak var transportName: UILabel!
    @IBOutlet weak var travelName: UILabel!
    @IBOutlet weak var sportName: UILabel!
    @IBOutlet weak var presentsName: UILabel!
    @IBOutlet weak var generalName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    //MARK: variables:
    
    var ref: DatabaseReference!
    let uid:String = Auth.auth().currentUser?.uid ?? "nil"
    let defaults = UserDefaults.standard
    var category = String()
    var icon = UIImage()
    var color = UIColor()
    var labels = [UILabel]()
    var index = Int()
    var date = Date()
    
    //MARK: buttons actions
    
    
    @IBAction func billsTapped(_ sender: UIButton) {
        category =  Categorys.bills.rawValue
        color = Categorys.bills.color
        icon = UIImage(systemName: "envelope.fill")!
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func travelTapped(_ sender: UIButton) {
        category = Categorys.travel.rawValue
        color = Categorys.travel.color
        icon = UIImage(systemName: "airplane")!
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func sportTapped(_ sender: UIButton) {
        category = Categorys.sport.rawValue
        color = Categorys.sport.color
        icon = #imageLiteral(resourceName: "sportIcon")
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func shppingTaped(_ sender: UIButton) {
        category = Categorys.shopping.rawValue
        color = Categorys.shopping.color
        icon = UIImage(systemName: "cart.fill")!
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func familyTapped(_ sender: UIButton) {
        category = Categorys.family.rawValue
        color = Categorys.family.color
        icon = UIImage(systemName: "house.fill")!
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func transportationTapped(_ sender: UIButton) {
        category = Categorys.transport.rawValue
        color = Categorys.transport.color
        icon = UIImage(systemName: "car.fill")!
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func entertainmentTapped(_ sender: UIButton) {
        category = Categorys.leisure.rawValue
        color = Categorys.leisure.color
        icon = UIImage(systemName: "film")!
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func groceriesTapped(_ sender: UIButton) {
        category = Categorys.groceries.rawValue
        color = Categorys.groceries.color
        icon = #imageLiteral(resourceName: "groceriesIcon")
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func healthTapped(_ sender: UIButton) {
        category = Categorys.health.rawValue
        color = Categorys.health.color
        icon = #imageLiteral(resourceName: "healthIcon")
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func restaurantsTapped(_ sender: UIButton) {
        category = Categorys.food.rawValue
        color = Categorys.food.color
        icon = #imageLiteral(resourceName: "restaurantsIcon")
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func presentsTapped(_ sender: UIButton) {
        category = Categorys.presents.rawValue
        icon = UIImage(systemName: "gift.fill")!
        color = Categorys.presents.color
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
    }
    
    @IBAction func generalTapped(_ sender: UIButton) {
        category = Categorys.general.rawValue
        color = Categorys.general.color
        icon =  UIImage(systemName: "globe")!
        performSegue(withIdentifier: "toExspenseKeyboard", sender: category)
        
    }
    
    
    @IBAction func backArrow(_ sender: UIButton) {
        
        switchDateArrow(minus:true)
        
    }
    
    @IBAction func nextArrow(_ sender: UIButton) {
        
        switchDateArrow(minus:false)
        
    }
    
    func switchDateArrow(minus:Bool){
        
        switch index {
            
        case 0:
            if minus{
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            }else{
                date = Calendar.current.date(byAdding: .day, value: +1, to: date)!
            }
            
            ActionDataSource.shared.categoryExpenseCoreData(index: index, billsLabel: billsAmount, shoppingLabel: shopingAmount, familyLabel: familyAmount, foodLabel: foodAmount, healthLabel: helthAmount, presentsLabel: presentsAmount, transportationLabel: transportationAmount, groceriesLabel: groceriesAmount, leisureLabel: leisureAmount, sportLabel: sportAmount, travrlLabel: travelAmount, generalLabel: generalAmount, totalLabel: totalExpences, date: date)
            
            let stringDate = Dates().castToString(date: date)
            dateLabel.text = stringDate
            
        case 1:
            
            if minus{
                date = Calendar.current.date(byAdding: .weekdayOrdinal, value: -1, to: date)!
            }else{
                date = Calendar.current.date(byAdding: .weekdayOrdinal, value: +1, to: date)!
            }
            
            ActionDataSource.shared.categoryExpenseCoreData(index: index, billsLabel: billsAmount, shoppingLabel: shopingAmount, familyLabel: familyAmount, foodLabel: foodAmount, healthLabel: helthAmount, presentsLabel: presentsAmount, transportationLabel: transportationAmount, groceriesLabel: groceriesAmount, leisureLabel: leisureAmount, sportLabel: sportAmount, travrlLabel: travelAmount, generalLabel: generalAmount, totalLabel: totalExpences, date: date)
            
            let days = WeekData().getDayOfThisWeek(date: date)
            let dateOne = Dates().dayAndMonth(string: days.first!)
            let dateTow = Dates().dayAndMonth(string: days.last!)
            dateLabel.text = "\(dateOne) - \(dateTow)"
            
            
        case 2:
            
            if minus{
                date = Calendar.current.date(byAdding: .month, value: -1, to: date)!
            }else{
                date = Calendar.current.date(byAdding: .month, value: +1, to: date)!
            }
            
            ActionDataSource.shared.categoryExpenseCoreData(index: index, billsLabel: billsAmount, shoppingLabel: shopingAmount, familyLabel: familyAmount, foodLabel: foodAmount, healthLabel: helthAmount, presentsLabel: presentsAmount, transportationLabel: transportationAmount, groceriesLabel: groceriesAmount, leisureLabel: leisureAmount, sportLabel: sportAmount, travrlLabel: travelAmount, generalLabel: generalAmount, totalLabel: totalExpences, date: date)
            
            let stringDate = Dates().castToString(date: date)
            let month = Dates().splitToMonth(string: stringDate)
            dateLabel.text = month
            
            
        case 3:
            
            if minus{
                date = Calendar.current.date(byAdding: .year, value: -1, to: date)!
            }else{
                date = Calendar.current.date(byAdding: .year, value: +1, to: date)!
            }
            
            ActionDataSource.shared.categoryExpenseCoreData(index: index, billsLabel: billsAmount, shoppingLabel: shopingAmount, familyLabel: familyAmount, foodLabel: foodAmount, healthLabel: helthAmount, presentsLabel: presentsAmount, transportationLabel: transportationAmount, groceriesLabel: groceriesAmount, leisureLabel: leisureAmount, sportLabel: sportAmount, travrlLabel: travelAmount, generalLabel: generalAmount, totalLabel: totalExpences, date: date)
            
            let stringDate = Dates().castToString(date: date)
            let year = Dates().splitToYear(string: stringDate)
            dateLabel.text = year
            
        default:
            break
        }
    }
    
    @IBAction func segment(_ sender: UISegmentedControl) {
        
        index = sender.selectedSegmentIndex
        let stringDate = Dates().castToString(date: Date())
        
        switch index {
        case 0:
            
            date = Date()
            dateLabel.text = stringDate
            
        case 1:
            
            date = Date()
            let days = WeekData().getDayOfThisWeek(date: Date())
            let dateOne = Dates().dayAndMonth(string: days.first!)
            let dateTow = Dates().dayAndMonth(string: days.last!)
            dateLabel.text = "\(dateOne) - \(dateTow)"
           
        case 2:
            
            date = Date()
            dateLabel.text = Dates().splitToMonth(string: stringDate)
            
        case 3:
            
            date = Date()
            dateLabel.text = Dates().splitToYear(string: stringDate)
            
        default:
            break
        }
        
        for i in 0..<10{
            
            if index == i {
                
                ActionDataSource.shared.categoryExpenseCoreData(index: i, billsLabel: billsAmount, shoppingLabel: shopingAmount, familyLabel: familyAmount, foodLabel: foodAmount, healthLabel: helthAmount, presentsLabel: presentsAmount, transportationLabel: transportationAmount, groceriesLabel: groceriesAmount, leisureLabel: leisureAmount, sportLabel:
                    sportAmount, travrlLabel: travelAmount, generalLabel: generalAmount, totalLabel: totalExpences, date: Date())
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormat = Dates().castToString(date: date)
        dateLabel.text = dateFormat
        
        labels = [presentsAmount,shopingAmount,groceriesAmount,helthAmount,foodAmount,billsAmount,familyAmount,leisureAmount,travelAmount,sportAmount,transportationAmount,generalAmount,generalName,presentsName,shoppingName,foodName,groceriesName,billsName,familyName,healthName,leisureName,transportName,travelName,sportName,generalName]
        
        presentIcon.backgroundColor = Categorys.presents.color
        foodIcon.backgroundColor = Categorys.food.color
        shoppingIcon.backgroundColor = Categorys.shopping.color
        groceriesIcon.backgroundColor = Categorys.groceries.color
        billsIcon.backgroundColor = Categorys.bills.color
        familyIcon.backgroundColor = Categorys.family.color
        healthIcon.backgroundColor = Categorys.health.color
        leisureIcon.backgroundColor = Categorys.leisure.color
        transportIcon.backgroundColor = Categorys.transport.color
        travelIcon.backgroundColor = Categorys.travel.color
        sportIcon.backgroundColor = Categorys.sport.color
        generalIcon.backgroundColor = Categorys.general.color
        
        ActionDataSource.shared.categoryExpenseCoreData(index: 0, billsLabel: billsAmount, shoppingLabel: shopingAmount, familyLabel: familyAmount, foodLabel: foodAmount, healthLabel: helthAmount, presentsLabel: presentsAmount, transportationLabel: transportationAmount, groceriesLabel: groceriesAmount, leisureLabel: leisureAmount, sportLabel: sportAmount, travrlLabel: travelAmount, generalLabel: generalAmount, totalLabel: totalExpences, date: Date())
        
        let iconsArr = [presentIcon,foodIcon,shoppingIcon,groceriesIcon,billsIcon,familyIcon,leisureIcon,generalIcon,travelIcon,sportIcon,transportIcon,healthIcon,transportIcon]
        
        let device =  UIDevice().name
        
        switch device {
            
        case "iPhone 8","iPhone 7","iPhone 6s":
            
            for l in labels{
                
                l.font = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 10)
            }
            
            for icon in iconsArr{
                
                icon?.layer.masksToBounds = true
                icon?.layer.cornerRadius = 20
                
            }
            
            totalExpences.font = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 32)
            
        default:
            
            totalExpences.font = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 48)
            
            for icon in iconsArr {
                
                 icon?.layer.masksToBounds = true
                 icon?.layer.cornerRadius = (icon?.frame.width)! / 2
                
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setDarkMode(view: self.view, labels: labels)
        
        segmentOT.selectedSegmentIndex = 0
        ActionDataSource.shared.categoryExpenseCoreData(index: 0, billsLabel: billsAmount, shoppingLabel: shopingAmount, familyLabel: familyAmount, foodLabel: foodAmount, healthLabel: helthAmount, presentsLabel: presentsAmount, transportationLabel: transportationAmount, groceriesLabel: groceriesAmount, leisureLabel: leisureAmount, sportLabel: sportAmount, travrlLabel: travelAmount, generalLabel: generalAmount, totalLabel: totalExpences, date: Date())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? KeyBoardViewController{
            dest.category = category
            dest.icon = icon
            dest.color = color
        }
    }
}

extension ExpensesViewController:ScreenMode{}

