//
//  MainTableViewController.swift
//  Project
//
//  Created by raz cohen on 20/05/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import SwiftUI



var indexPathAndValueArr = [[IndexPath : Action]]()

var fetchd:NSFetchedResultsController<Action> = {
    
    let request = NSFetchRequest<Action>(entityName: "Action")
        
    //sorted by:

    request.sortDescriptors = [
        
         NSSortDescriptor(key: "date", ascending: false),
         NSSortDescriptor(key: "amount", ascending: false)
        
    ]
        
    let context = CoreDatabase.shared.context

    let fetchedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath:#keyPath(Action.date), cacheName: "fileName")

    
    return fetchedController
}()

class MainTableViewController: BaseTableViewController {
    
    private var searchController:UISearchController!
    private var resultsTableController:ResultsTableViewController!
    var numberOfObjectsInCurrentSection = Int()
    var sectionsChanged = false
    let storage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isItDarkMode(){
             self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3254901961, alpha: 1)
        }
        
        setDarkMode(view: self.view, labels: nil)
        fetchd.delegate = self
        
        do{
            
            let uid = HomeViewController.uid
            
            print("user id fetched!! ",uid)
            
            fetchd.fetchRequest.predicate = NSPredicate(format: "userID == %@" , uid )
        
            try fetchd.performFetch()
            
            print("$ actions in table: ",fetchd.fetchedObjects!.count)
            
        }catch let error{
            print(error)
            
        }
        setupSearch()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "trash")
    }
    
     override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
        
        print(fetchd.fetchedObjects?.count ?? 0)
        
          if isItDarkMode(){
               self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1803921569, green: 0.2509803922, blue: 0.3254901961, alpha: 1)
          }else{
               self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
          }
          createDictArray()
          setDarkMode(view: self.view, labels: nil)
          tableView.reloadData()
        
          }
    
      // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        view.backgroundColor = #colorLiteral(red: 0.77131778, green: 0.7798765898, blue: 1, alpha: 1)
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.width - 16, height: 40))
        let stringDate = fetchd.sections![section].name
        let arr = stringDate.components(separatedBy: " ")
        let dateArr = arr[0]
        let wantedArr = dateArr.components(separatedBy: "-")
        let year = wantedArr[0]
        let month = wantedArr[1]
        let day = wantedArr[2]
        label.text = "\(day)/\(month)/\(year)"
        label.font = UIFont(name: "Hiragino Maru Gothic Pro W4", size: 20)
        label.textColor = #colorLiteral(red: 0.2862745098, green: 0.3450980392, blue: 0.4039215686, alpha: 1)
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func createDictArray(){
        indexPathAndValueArr.removeAll()
        let allIndexPaths = getAllIndexPathsInTable()
        let numberOfObj = fetchd.fetchedObjects!.count
        for i in 0..<numberOfObj{
            let dict = [allIndexPaths[i] : fetchd.fetchedObjects![i]]
            indexPathAndValueArr.append(dict)
        }
    }

    
    func getAllIndexPathsInTable() -> [IndexPath] {
        var arr = [IndexPath]()
        let nSections = fetchd.sections!.count
          for j in 0..<nSections {
            let nRows = fetchd.sections?[j].numberOfObjects ?? 0
              for i in 0..<nRows {
                let indexPath = IndexPath(row: i, section: j)
                arr.append(indexPath)
              }
           }
        return arr
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchd.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchd.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier, for: indexPath)as? ActionTableViewCell else{fatalError("No cell")}
        configureCell(cell, forExpense: fetchd.object(at: indexPath))
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
    
    func setupSearch(){
        resultsTableController = ResultsTableViewController()
        searchController = UISearchController(searchResultsController: resultsTableController)
        
        //the search callback: (UISearchResultsUpdating protocol)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocorrectionType = .no
        
        if isItDarkMode(){
            
           searchController.searchBar.barStyle = .black
        }else{
            
            searchController.searchBar.barStyle = .default
        }
        
        //place the searchController:
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
     if editingStyle == .delete {
        
     // Delete the row from the data source
        let action = fetchd.object(at: indexPath)
        let sections = fetchd.sections
        let section = sections![indexPath.section]
        numberOfObjectsInCurrentSection = section.numberOfObjects
        deleteImageFromFirebase(action:action)
        CoreDatabase.shared.context.delete(action)
        CoreDatabase.shared.saveContext()
        
      }
     }
    
    func deleteImageFromFirebase(action:Action? = nil){
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let action = fetchd.object(at: indexPath)
         performSegue(withIdentifier: "fromExTableToEdit", sender: action)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let dest = segue.destination as? EditViewController else{
             return
         }
         if let a = sender as? Action{
             dest.action = a
         }
     }
}

extension MainTableViewController:UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let q = searchController.searchBar.text ?? ""
        let filterResults = fetchd.fetchedObjects?.filter{
            let stringDate = Dates().castToString(date: $0.date)
            return
            $0.detail?.range(of: q, options: .caseInsensitive) != nil ||
            $0.category.range(of: q, options: .caseInsensitive) != nil ||
            stringDate.range(of: q, options: .caseInsensitive) != nil
        }
        if let resultsController = searchController.searchResultsController as? ResultsTableViewController{
            resultsController.filteredTable = filterResults!
            resultsController.tableView.reloadData()
        }
    }
}

extension MainTableViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MainTableViewController:UISearchControllerDelegate{}

extension MainTableViewController:NSFetchedResultsControllerDelegate{

func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
        
        print("!!!insert")
        tableView.insertRows(at: [newIndexPath!], with: .fade)
        
    case .update:
        print("!!!update")
        if let path = indexPath,let cell = tableView.cellForRow(at: path) as? ActionTableViewCell{
            let a = fetchd.object(at: path)
            if a.userID == HomeViewController.uid{
                cell.populate(a:a)
            }
        }
        
    case .move:
        print("!!move")
        
        tableView.moveRow(at: indexPath!, to: newIndexPath!)
    
    case .delete:
        
        print("!!!delete")
        tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath!], with: .none)
        
        createDictArray()
        tableView.endUpdates()
        
    default:
        break
    }
  }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
            case .insert:
                print("!!!insert section")
                tableView.insertSections(
                    NSIndexSet(index: sectionIndex) as IndexSet,
                    with: .fade)
            case .delete:
                tableView.deleteSections(
                    NSIndexSet(index: sectionIndex) as IndexSet,
                    with: .fade)
            default:
                break
        }

        sectionsChanged = true
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension MainTableViewController:ScreenMode{}


