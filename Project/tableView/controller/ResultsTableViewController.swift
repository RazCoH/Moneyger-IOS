//
//  ResultsTableViewController.swift
//  Project
//
//  Created by raz cohen on 20/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ResultsTableViewController: BaseTableViewController {
    
    let storage = Storage.storage()
    static let resultsTable = UITableViewController.self
    var sectionsChanged = false
    var numberOfRowInSection = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode(view: self.view, labels: nil)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTable.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier, for: indexPath)as? ActionTableViewCell else{fatalError("No cell")}
        let expense = filteredTable[indexPath.row]
        configureCell(cell , forExpense: expense)
        let users = CoreDatabase.shared.fetchUser()
        for u in users{
            if u.id == HomeViewController.uid{
                if u.darkMode{
                    
                    cell.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3254901961, alpha: 1)
                    cell.dateLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    cell.categoryLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    cell.detailLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    cell.layer.borderColor = #colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1)
                    cell.layer.borderWidth = 0.2
                    
                }else{
                    
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    cell.dateLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    cell.categoryLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    cell.detailLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    cell.layer.borderColor = #colorLiteral(red: 0.5764705882, green: 0.5058823529, blue: 1, alpha: 1)
                    cell.layer.borderWidth = 0.2
                }
                break
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            // Delete the row from the data source
            let action = filteredTable[indexPath.row]
            filteredTable.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            deleteImageFromFirebase(action: action)
            for dict in indexPathAndValueArr{
                for (k,v) in dict{
                    if action == v {
                        CoreDatabase.shared.context.delete(fetchd.object(at: k))
                        indexPathAndValueArr.remove(at: k.row)
                        CoreDatabase.shared.saveContext()
                        return
                    }
                }
            }
        }
    }
    
    func deleteImageFromFirebase(action:Action? = nil ){ //, profit:Profit? = nil
        //delete from firebase:
        let image = action?.imageUrl ?? ""
        
        if image != "" {
            let storegeRef = storage.reference().child("Images").child(image)
            storegeRef.delete { (error) in
                if let error = error{
                    print("Error!",error)
                }else{
                    print("Delete succefully!")
                }
            }
            //delete from realtime db:
            let ref = Database.database().reference()
            let uid = Auth.auth().currentUser!.uid
            let imageFullName = image.components(separatedBy: ".")
            let imageName = imageFullName[0]
            ref.child("users").child(uid).child("images").child(imageName).removeValue()
        }
    }
}

extension ResultsTableViewController:ScreenMode{}


