//
//  MenuViewController.swift
//  Project
//
//  Created by raz cohen on 30/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import MessageUI
import SystemConfiguration

struct cellData{
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
    
}
class MenuViewController: UITableViewController,CurrencyDelegate{
    
    var tableViewData = [cellData]()
   
    var chosenNewCurrency = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sb = UIStoryboard(name: "ExchangePopUp", bundle: .main)
        guard let vc = sb.instantiateViewController(identifier: "exchange") as? ExchangePopUpViewController else{return}
        vc.delegateCur = self
        vc.delegate = self
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 120))
        let label = UILabel(frame: CGRect(x: 120, y: 32, width: view.frame.width - 48, height: 60))
        label.text = "Moneyger"
        label.font = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 20)
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        let icon = UIImageView(image: UIImage(imageLiteralResourceName: "logo"))
        icon.frame = CGRect(x: 16, y: 16, width: 100, height: 100)
        view.addSubview(label)
        view.addSubview(icon)
        view.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
        self.tableView.tableHeaderView = view
        
        
        tableViewData = [
            cellData(opened: false, title: "Reset Data"),
            cellData(opened: false, title: "Screen Mode", sectionData: ["Dark","Bright"]),
            cellData(opened: false, title: "Currency"),
            cellData(opened: false, title: "Contact Us"),
            cellData(opened: false, title: "Log Out")
            
        ]
        tableView.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "optionCell")
        
    }
    
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened{
            return tableViewData[section].sectionData.count + 1
        }else{
           return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let icons:[UIImage] = [
                               UIImage(systemName:"trash")!,
                               UIImage(systemName:"paintbrush")!,
                               UIImage(systemName:"dollarsign.circle")!,
                               UIImage(systemName: "envelope")!,
                               UIImage(systemName:"hand.raised")!.sd_rotatedImage(withAngle: 32, fitSize: true)!.sd_tintedImage(with: #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1))!
        ]
                
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")else{
                return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].title
            cell.imageView?.image = icons[indexPath.section]
            cell.imageView?.tintColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 24)
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell")else{
                return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            cell.textLabel?.textColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 1, alpha: 1)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            return cell
        }
    }
    
    func transitionToHome(){
                   let sb = UIStoryboard(name: "Main", bundle: .main)
                   let tbvc = sb.instantiateViewController(withIdentifier: "tabBar") as? tabBarController
                   view.window?.rootViewController = tbvc
                   view.window?.makeKeyAndVisible()
               }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableViewData[indexPath.section].opened == true{
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
            
            let chosen = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
            let users = CoreDatabase.shared.fetchUser()
            switch chosen {
            case "Dark":
                
                for u in users{
                    if u.id == HomeViewController.uid{
                        u.setValue(true, forKey: "darkMode")
                        CoreDatabase.shared.saveContext()
                        transitionToHome()
                    }
             }
                
            case "Bright":
                for u in users{
                    if u.id == HomeViewController.uid{
                        u.setValue(false, forKey: "darkMode")
                        CoreDatabase.shared.saveContext()
                        transitionToHome()
                    }
                }
            default:
                break
            }
            
        }else{
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)

            let chosen = tableViewData[indexPath.section].title
            switch chosen {
            case "Contact Us":
                print("Contact Us")
                tableViewData[indexPath.section].opened = false
                showEmailComposer()
                
            case "Reset Data":
                print("Reset Data")
                tableViewData[indexPath.section].opened = false
                let alert = UIAlertController(title: "Are You Sure?",
                                              message: "All of your data will be lost",
                                              preferredStyle: .alert)
                
                alert.addAction(.init(title: "Reset", style: .default, handler: {(action) in
                    let actions = CoreDatabase.shared.fetchAction()
                    for a in actions{
                        CoreDatabase.shared.context.delete(a)
                    }
                    CoreDatabase.shared.saveContext()
                }))
                
                alert.addAction(.init(title: "Close", style: .destructive, handler: { (action) in}))
                
                present(alert, animated: true)
            
            case "Currency":
                
                tableViewData[indexPath.section].opened = false
                
                let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
                var flags = SCNetworkReachabilityFlags()
                SCNetworkReachabilityGetFlags(reachability!, &flags)
                
                if CheckInternet().isConnected(with: flags){
                    
                let sb = UIStoryboard(name: "ExchangePopUp", bundle: .main)
                guard let vc = sb.instantiateViewController(identifier: "exchange") as? ExchangePopUpViewController else{return}
                present(vc, animated: true)
                vc.delegateCur = self
                vc.delegate = self
                    
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
                
            case "Log Out":
                tableViewData[indexPath.section].opened = false
                do{
                    try Auth.auth().signOut()
                    Rauter.shared.chooseMainViewController()
                    
                }catch let error{
                    print("Error!",error)
                }
                
            default:
                break
            }
        }
      }
    
    func showEmailComposer(){
        guard MFMailComposeViewController.canSendMail() else{ let alert = showAlert(title: "Error", message: "Can't send an email")
            present(alert,animated: true)
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["razco55@gmail.com"])
        composer.setSubject("Support")
        present(composer,animated: true)
        
    }
    
    func getCur(currency: String) {
          let users = CoreDatabase.shared.fetchUser()
          for u in users{
              if u.id == HomeViewController.uid{
               u.setValue(currency, forKey: "userCurrency")
                  print("chosen!!",currency)
              }
          }
          CoreDatabase.shared.saveContext()
      }
    
}

protocol CurrencyDelegate{
    func getCur(currency:String)
}

extension MenuViewController:RateDelegate{
    func getRate(rate: Double) {

        let actions = CoreDatabase.shared.fetchAction()
        for a in actions{
            if a.userID == HomeViewController.uid{
                let amount = a.amount

                   let afterChangeAmount = amount / rate

                a.setValue(afterChangeAmount, forKey: "amount")
                CoreDatabase.shared.saveContext()
            }
        }
         transitionToHome()
    }
}
extension MenuViewController:Alert{}

extension MenuViewController:MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error{
            //show alert
            controller.dismiss(animated: true)
        }
        
        switch result {
        case .cancelled:
            print("canceled")
        case .failed:
            print("failed")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}
