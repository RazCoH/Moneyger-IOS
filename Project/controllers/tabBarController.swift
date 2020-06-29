//
//  tabBarController.swift
//  Project
//
//  Created by raz cohen on 31/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class tabBarController:UITabBarController{
    
    override func viewDidLoad() {
       // UINavigationBar.appearance()
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
    }
}

