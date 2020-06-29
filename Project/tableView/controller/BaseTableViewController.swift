//
//  BaseTableViewController.swift
//  Project
//
//  Created by raz cohen on 20/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var filteredTable = [Action]()
    static let tableViewCellIdentifier = "actionCell"
    private static let nibName = "ActionTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName:BaseTableViewController.nibName, bundle: nil)
                  tableView.register(nib, forCellReuseIdentifier:
                  BaseTableViewController.tableViewCellIdentifier)
    }

   
    //MARK: configuration
    
    func configureCell(_ cell: ActionTableViewCell,forExpense a:Action){
        if a.userID == HomeViewController.uid{
        cell.populate(a: a)
        }
    }
}
