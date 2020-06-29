//
//  ActionTableViewCell.swift
//  Project
//
//  Created by raz cohen on 20/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {
    
    //MARK: outlets
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var iconBtn: UIButton!
    
    func populate(a:Action){

        if a.userID == HomeViewController.uid{
        categoryLabel.text = a.category
        detailLabel.text = a.detail
        let date = a.date
        dateLabel.text = Dates().castToString(date: date)
        let amount = a.amount
        let amountFormatted = ActionDataSource.shared.currencyFormat(amount: amount)
        if a.isItExpense{
            numberLabel.text = "-\(amountFormatted)"
            numberLabel.textColor = .red
        }else{
            numberLabel.text = "+\(amountFormatted)"
            numberLabel.textColor = .green
        }
        let icon = getCatIcon(action: a)
        iconBtn.tintColor = .white
        iconBtn.setImage(icon, for: .normal)
        iconBtn.backgroundColor = getCatColor(category: a.category)
        iconBtn.layer.masksToBounds = true
        iconBtn.layer.cornerRadius = (iconBtn.frame.height) / 2
    }
  }
}


protocol GetCategoryIcon{}

extension GetCategoryIcon{
    func getCatIcon(action:Action)->UIImage{
        let category = action.category
        switch category {
        case Categorys.bills.rawValue:
            
            return UIImage(systemName: "envelope.fill")!
            
        case Categorys.shopping.rawValue:
            
            return UIImage(systemName: "cart.fill")!
            
        case Categorys.family.rawValue:
            
            return UIImage(systemName: "house.fill")!
            
        case Categorys.health.rawValue:
            
            return #imageLiteral(resourceName: "healthIcon")
            
        case Categorys.food.rawValue:
            
            return #imageLiteral(resourceName: "restaurantsIcon")
            
        case Categorys.presents.rawValue,Categorys.gifts.rawValue:
            
            return UIImage(systemName: "gift.fill")!
            
        case Categorys.salary.rawValue:
            
            return UIImage(systemName: "dollarsign.circle.fill")!
            
        case Categorys.investments.rawValue:
            
            return UIImage(systemName: "briefcase.fill")!
            
        case Categorys.groceries.rawValue:
            
            return #imageLiteral(resourceName: "groceriesIcon")
            
        case Categorys.leisure.rawValue:
            
            return UIImage(systemName: "film")!
            
        case Categorys.transport.rawValue:
            
            return UIImage(systemName: "car.fill")!
            
        case Categorys.sport.rawValue:
            
            return #imageLiteral(resourceName: "sportIcon")
            
        case Categorys.travel.rawValue:
            
            return UIImage(systemName: "airplane")!
            
        case Categorys.general.rawValue,Categorys.global.rawValue:
            
            return UIImage(systemName: "globe")!
        default:
            return #imageLiteral(resourceName: "wallet")
        }
    }
    
    func getCatColor(category:String)->UIColor{
        switch category {
        case Categorys.bills.rawValue:
            
            return Categorys.bills.color
            
        case Categorys.shopping.rawValue:
            
            return Categorys.shopping.color
            
        case Categorys.family.rawValue,Categorys.salary.rawValue:
            
            return Categorys.family.color
            
        case Categorys.health.rawValue,Categorys.global.rawValue:
            
            return Categorys.health.color
            
        case Categorys.food.rawValue:
            
            return Categorys.food.color
            
        case Categorys.presents.rawValue:
        
            return Categorys.presents.color
            
        case Categorys.groceries.rawValue:
            
            return Categorys.groceries.color
            
        case Categorys.leisure.rawValue,Categorys.gifts.rawValue:
            
            return Categorys.leisure.color
            
        case Categorys.transport.rawValue:
            
            return Categorys.transport.color
            
        case Categorys.sport.rawValue:
            
            return Categorys.sport.color
            
        case Categorys.travel.rawValue,Categorys.investments.rawValue:
            
            return Categorys.travel.color
            
        case Categorys.general.rawValue:
            
            return Categorys.general.color
        default:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
extension ActionTableViewCell:GetCategoryIcon{}
extension UIViewController:GetUserCurrency{}
extension AnalitycsDataSource:GetUserCurrency{}
extension ActionDataSource:GetUserCurrency{}
extension ActionTableViewCell:GetUserCurrency{}
extension ActionTableViewCell:ScreenMode{}



