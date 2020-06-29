//
//  ProfitViewController.swift
//  Project
//
//  Created by raz cohen on 26/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase



class ProfitViewController: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormat = Dates().castToString(date: date)
        dateLabel.text = dateFormat
        
        labels = [salaryName,salaryAmountLabel,investmentsName,investmentsAmountLabel,giftAmountLabel,giftsName,globalName,generalAmountLabel]
        
        ActionDataSource.shared.categoryProfitCoreData(index: 0,
                                                       salaryLabel: salaryAmountLabel,
                                                       giftLabel: giftAmountLabel,
                                                       investmentsLabel: investmentsAmountLabel, gloabalLabel: generalAmountLabel, totalLabel:totalProfitAmountLabel, date: Date())
        
        let iconsArr = [salaryIcon,giftIcon,investIcon,generalIcon]
        
        salaryIcon.backgroundColor = Categorys.salary.color
        giftIcon.backgroundColor = Categorys.gifts.color
        investIcon.backgroundColor = Categorys.investments.color
        generalIcon.backgroundColor = Categorys.global.color
        
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
            
            default:
            
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
        
        ActionDataSource.shared.categoryProfitCoreData(index: 0,
                                                       salaryLabel: salaryAmountLabel, giftLabel: giftAmountLabel, investmentsLabel: investmentsAmountLabel, gloabalLabel: generalAmountLabel, totalLabel:totalProfitAmountLabel, date: Date())
        
    }
    //MARK: variables
    
    var ref:DatabaseReference!
    let uid:String = Auth.auth().currentUser?.uid ?? "nil"
    var category = String()
    var icon = UIImage()
    var color = UIColor()
    var index = Int()
    var date = Date()
    var labels = [UILabel]()

    //MARK: outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var giftAmountLabel: UILabel!
    @IBOutlet weak var investmentsAmountLabel: UILabel!
    @IBOutlet weak var salaryAmountLabel: UILabel!
    @IBOutlet weak var totalProfitAmountLabel: UILabel!
    @IBOutlet weak var segmentOT: UISegmentedControl!
    @IBOutlet weak var generalAmountLabel: UILabel!
    
    @IBOutlet weak var globalName: UILabel!
    @IBOutlet weak var salaryIcon: UIButton!
    @IBOutlet weak var giftIcon: UIButton!
    @IBOutlet weak var investIcon: UIButton!
    @IBOutlet weak var generalIcon: UIButton!
    @IBOutlet weak var investmentsName: UILabel!
    @IBOutlet weak var giftsName: UILabel!
    @IBOutlet weak var salaryName: UILabel!
    
    
    //MARK: functions
    
    @IBAction func addSalary(_ sender: UIButton) {
        category = Categorys.salary.rawValue
        color = Categorys.salary.color
        icon = UIImage(systemName: "dollarsign.circle.fill")!
        performSegue(withIdentifier: "toProfitsKeyboard", sender: category)
        
    }
    
    @IBAction func addGift(_ sender: UIButton) {
        category = Categorys.gifts.rawValue
        color =  Categorys.gifts.color
        icon = UIImage(systemName: "gift.fill")!
        performSegue(withIdentifier: "toProfitsKeyboard", sender: category)
    }
    
    @IBAction func addInvestments(_ sender: UIButton) {
        category = Categorys.investments.rawValue
        color =  Categorys.travel.color
        icon = UIImage(systemName: "briefcase.fill")!
        performSegue(withIdentifier: "toProfitsKeyboard", sender: category)
    }
    
    @IBAction func addGeneral(_ sender: UIButton) {
        category = Categorys.global.rawValue
        color = Categorys.global.color
        icon = UIImage(systemName: "globe")!
        performSegue(withIdentifier: "toProfitsKeyboard", sender: self)
    }
    //MARK: actions
    
    
    @IBAction func backArrow(_ sender: UIButton) {
        
        switchDateArrow(minus: true)
        
    }
    
    @IBAction func nextArrow(_ sender: UIButton) {
        
        switchDateArrow(minus: false)
        
    }
    
    func switchDateArrow(minus:Bool){
        
        switch index {
            
        case 0:
            if minus{
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            }else{
                date = Calendar.current.date(byAdding: .day, value: +1, to: date)!
            }
            
            ActionDataSource.shared.categoryProfitCoreData(index: index, salaryLabel: salaryAmountLabel, giftLabel: giftAmountLabel, investmentsLabel: investmentsAmountLabel, gloabalLabel: generalAmountLabel, totalLabel: totalProfitAmountLabel, date: date)
            
            let stringDate = Dates().castToString(date: date)
            dateLabel.text = stringDate

        case 1:
            
            if minus{
                date = Calendar.current.date(byAdding: .weekdayOrdinal, value: -1, to: date)!
            }else{
                date = Calendar.current.date(byAdding: .weekdayOrdinal, value: +1, to: date)!
            }
            
            ActionDataSource.shared.categoryProfitCoreData(index: index, salaryLabel: salaryAmountLabel, giftLabel: giftAmountLabel, investmentsLabel: investmentsAmountLabel, gloabalLabel: generalAmountLabel, totalLabel: totalProfitAmountLabel, date: date)
            
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
            
             ActionDataSource.shared.categoryProfitCoreData(index: index, salaryLabel: salaryAmountLabel, giftLabel: giftAmountLabel, investmentsLabel: investmentsAmountLabel, gloabalLabel: generalAmountLabel, totalLabel: totalProfitAmountLabel, date: date)
            
            let stringDate = Dates().castToString(date: date)
            let month = Dates().splitToMonth(string: stringDate)
            dateLabel.text = month
            
            
        case 3:
            
            if minus{
                date = Calendar.current.date(byAdding: .year, value: -1, to: date)!
            }else{
                date = Calendar.current.date(byAdding: .year, value: +1, to: date)!
            }
            
            ActionDataSource.shared.categoryProfitCoreData(index: index, salaryLabel: salaryAmountLabel, giftLabel: giftAmountLabel, investmentsLabel: investmentsAmountLabel, gloabalLabel: generalAmountLabel, totalLabel: totalProfitAmountLabel, date: date)
            
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
        
        for i in 0..<4{
            
            if index == i {
                
                ActionDataSource.shared.categoryProfitCoreData(index: i,
                                                               salaryLabel: salaryAmountLabel, giftLabel: giftAmountLabel, investmentsLabel: investmentsAmountLabel, gloabalLabel: generalAmountLabel, totalLabel:totalProfitAmountLabel, date: Date())
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? KeyBoardViewController{
            dest.icon = icon
            dest.color = color
            dest.category = category
        }
    }
}

extension ProfitViewController:ScreenMode{}






