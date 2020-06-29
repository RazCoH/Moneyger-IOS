//
//  HomeViewController.swift
//  Project
//
//  Created by raz cohen on 24/03/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import SideMenu
import CoreData



class HomeViewController: UIViewController {
    
    static var uid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a = CoreDatabase.shared.fetchAction()

        print("$ actions in home: ",a.count)
    
        print(LogInViewController.userID,"!!")
        
        if LogInViewController.userID != ""{
            
            HomeViewController.uid = LogInViewController.userID
            
            
        }else{
            
            HomeViewController.uid = Auth.auth().currentUser!.uid
        }

        menu = SideMenuNavigationController(rootViewController: MenuViewController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        guard let menu = menueOutlet.currentImage else{return}
        let resizedMenu = menu.resized(with: CGSize(width: 40, height: 32)).withTintColor(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 1, alpha: 1))
        menueOutlet.setImage(resizedMenu, for: .normal)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
        
    }
    
    var startValue = 0.0
   
    let animationStartDate = Date()
    let animationDuration = 2.0
    
    @objc func handleUpdate(){
        
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
    
        Totals.shared.getDifference {[weak self] (difference) in
            
            let differenceFormat = ActionDataSource.shared.currencyFormat(amount: difference)
            let endValue = difference
            
            if elapsedTime > self!.animationDuration{
                
                if difference >= 0{
                    
                    self?.amountLabel.text = "+\(differenceFormat)"
                    
                }else{
                    
                    self?.amountLabel.text = "-\(differenceFormat)"
                }
                
            }else{
                
                let percentage = elapsedTime / self!.animationDuration
                let value = percentage * (endValue - self!.startValue)
                let valueFormatted = ActionDataSource.shared.currencyFormat(amount: value)
                self?.amountLabel.text = "\(valueFormatted)"
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Totals.shared.getDifference {[weak self] (difference) in
            let differenceFormat = ActionDataSource.shared.currencyFormat(amount: difference)
            if difference >= 0{
                self?.amountLabel.text = "+\(differenceFormat)"
            }else{
                self?.amountLabel.text = "-\(differenceFormat)"
            }
        }
    }
    
    //MARK: variables:
    
    var ref: DatabaseReference!
    var menu:SideMenuNavigationController?
    
    //MARK: outlets
    
    @IBOutlet weak var exspenceView: UIView!
    @IBOutlet weak var profitView: UIView!
    @IBOutlet weak var mySegment: UISegmentedControl!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var menueOutlet: UIButton!
    
    //MARK: actions
    
    @IBAction func changePage(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            exspenceView.alpha = 1
            profitView.alpha = 0
        }else{
            exspenceView.alpha = 0
            profitView.alpha = 1
        }
    }
    
    
    @IBAction func menuBtn(_ sender: UIButton) {
        present(menu!,animated: true)
    }
}



