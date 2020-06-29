//
//  Keys.swift
//  Project
//
//  Created by raz cohen on 31/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import Foundation
import UIKit

enum CodingKeys:String{
    case date = "date"
    case category = "category"
    case amount = "amount"
    case detail = "detail"
    case key = "key"
}

struct Category{
    let name:String
    let color:UIColor
}

    enum Categorys:String,CaseIterable{
         
        case bills = "Bills"
        case food = "Food"
        case general = "General"
        case groceries = "Groceries"
        case health = "Health"
        case leisure = "Leisure"
        case presents = "Presents"
        case salary = "Salary"
        case shopping = "Shopping"
        case sport = "Sport"
        case transport = "Transport"
        case gifts = "Gifts"
        case investments = "Investments"
        case global = "Global"
        case family = "Family"
        case travel = "Travel"
        
        var color:UIColor{
            switch self {
            case .bills:
                return #colorLiteral(red: 0.6117647059, green: 0.6862745098, blue: 0.7176470588, alpha: 1)
            case .shopping:
                return #colorLiteral(red: 0.4392156863, green: 0.7568627451, blue: 0.7019607843, alpha: 1)
            case .family,.salary:
                return #colorLiteral(red: 0.2588235294, green: 0.5058823529, blue: 0.6431372549, alpha: 1)
            case .health,.global:
                return #colorLiteral(red: 1, green: 0.8784313725, blue: 0.4, alpha: 1)
            case .food:
                return #colorLiteral(red: 0.3333333333, green: 0.3568627451, blue: 0.431372549, alpha: 1)
            case .presents:
                return #colorLiteral(red: 0.9490196078, green: 0.3725490196, blue: 0.3607843137, alpha: 1)
            case .groceries:
                return #colorLiteral(red: 0.09803921569, green: 0.4470588235, blue: 0.4705882353, alpha: 1)
            case .leisure,.gifts:
                return #colorLiteral(red: 0.9960784314, green: 0.5764705882, blue: 0.5490196078, alpha: 1)
            case .transport:
                return #colorLiteral(red: 0.5333333333, green: 0.831372549, blue: 0.5960784314, alpha: 1)
            case .sport:
                return #colorLiteral(red: 0.6784313725, green: 0.6549019608, blue: 0.7882352941, alpha: 1)
            case .travel,.investments:
                return #colorLiteral(red: 0.6588235294, green: 0.8549019608, blue: 0.862745098, alpha: 1)
            case .general:
                return #colorLiteral(red: 0.968627451, green: 0.6156862745, blue: 0.3960784314, alpha: 1)
            }
        }
    }



