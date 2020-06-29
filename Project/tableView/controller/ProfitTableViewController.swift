//
//  ProfitTableViewController.swift
//  Project
//
//  Created by raz cohen on 13/04/2020.
//  Copyright © 2020 raz cohen. All rights reserved.
//

import UIKit
import CoreData
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth


class ProfitTableViewController: UITableViewController {}
    
//    //MARK: variables
//    lazy var fetchd:NSFetchedResultsController<Profit> = {
//        let request = NSFetchRequest<Profit>(entityName: "Profit")
//
//        //sorder by:
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "date", ascending: false),
//            NSSortDescriptor(key: "amount", ascending: false)
//        ]
//        let context = CoreDatabase.shared.context
//        let fetchedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "date" , cacheName: "fileName")
//        return fetchedController
//    }()
//
//    var sarchCellArr = [Profit]()
//    var searching = false
//    var numberOfObjectsInCurrentSection = Int()
//    var sectionsChanged = false
//
//    //MARK: outlets
//
//    @IBOutlet weak var searchBar: UISearchBar!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        searchBar.delegate = self
//        fetchd.delegate = self
//
//        do{
//            try fetchd.performFetch()
//        }catch let error{
//            print(error)
//        }
//    }
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return fetchd.fetchedObjects!.count
//    }
//
//    func fetchData(_ searchElement:String){
//        self.sarchCellArr.removeAll()
//        let profits = CoreDatabase.shared.fetchProfit()
//        for p in profits{
//            let category = p.category
//            let date = Dates().castToString(date: p.date)
//            let day = Dates().daySearch(string: date)
//            let mounthAndDay = Dates().dayAndMonthSearch(string: date)
//            let year = Dates().splitToYear(string: date)
//            let month = Dates().splitToMonth(string: date)
//            let detail = p.detail
//
//            if category.caseInsensitiveCompare(searchElement) == .orderedSame
//                || detail?.caseInsensitiveCompare(searchElement) == .orderedSame
//                || mounthAndDay.caseInsensitiveCompare(" \(searchElement)") == .orderedSame
//                || day.caseInsensitiveCompare(searchElement) == .orderedSame
//                || month.caseInsensitiveCompare(searchElement) == .orderedSame
//                || year.caseInsensitiveCompare(" \(searchElement)") == .orderedSame{
//                self.sarchCellArr.append(p)
//            }
//        }
//        tableView.reloadData()
//    }
//
//    // MARK: - Table view data source
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        let search = searchBar.text
//        if searching{
//            if sarchCellArr.count == 0{
//                return "No results for \(search ?? "")"
//            }
//            return "Results for \(search ?? ""):"
//        }else{
//            let stringDate = fetchd.sections![section].name
//            let arr = stringDate.components(separatedBy: " ")
//            let dateArr = arr[0]
//            let wantedArr = dateArr.components(separatedBy: "-")
//            let year = wantedArr[0]
//            let month = wantedArr[1]
//            let day = wantedArr[2]
//            return "\(day)/\(month)/\(year)"
//        }
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if searching{
//            return 1
//        }else{
//            return fetchd.sections?.count ?? 0
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searching{
//            return sarchCellArr.count
//        }else{
//            return fetchd.sections?[section].numberOfObjects ?? 0
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "profitCell", for: indexPath)
//
//        if searching{
//            let singleProfit = sarchCellArr[indexPath.row]
//            if let cell = cell as? ProfitTableViewCell{
//                cell.populate(p: singleProfit)
//            }
//        }else{
//            if let cell = cell as? ProfitTableViewCell{
//                let p = fetchd.object(at: indexPath)
//                cell.populate(p: p)
//            }
//        }
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//
//            if searching{
//                //TODO: fix!
//                let singleProfit = sarchCellArr[indexPath.row]
//                CoreDatabase.shared.context.delete(singleProfit)
//                CoreDatabase.shared.saveContext()
//            }else{
//                let singleProfit = fetchd.object(at: indexPath)
//                let sections = fetchd.sections
//                let section = sections![indexPath.section]
//
//                //delete from storage:
//                if let imageUrl = singleProfit.imageUrl{
//                    let storage = Storage.storage()
//                    let storegeRef = storage.reference().child("Images").child(imageUrl)
//                    storegeRef.delete { (error) in
//                        if let error = error{
//                            print("Error!",error)
//                        }else{
//                            print("Delete succefully!")
//                        }
//                    }
//                    //delete from realtime db:
//                    let ref = Database.database().reference()
//                    let uid = Auth.auth().currentUser!.uid
//                    let imageFullName = imageUrl.components(separatedBy: ".")
//                    let imageName = imageFullName[0]
//                    ref.child("users").child(uid).child("images").child(imageName).removeValue()
//                }
//
//
//
//
//                numberOfObjectsInCurrentSection = section.numberOfObjects
//                CoreDatabase.shared.context.delete(singleProfit)
//                CoreDatabase.shared.saveContext()
//            }
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let profit = fetchd.object(at: indexPath)
//        performSegue(withIdentifier: "fromProfTableToEdit", sender: profit)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let dest = segue.destination as? EditViewController else{
//            return
//        }
//        if let p = sender as? Profit{
//            dest.profit = p
//        }
//    }
//}
//
//extension ProfitTableViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searching = true
//        guard let text = searchBar.text else {
//            return
//        }
//        fetchData(text)
//        self.view.endEditing(true)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty{
//            searching = false
//            tableView.reloadData()
//        }
//    }
//}
//
//
//extension ProfitTableViewController:NSFetchedResultsControllerDelegate{
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        case .update:
//            print("!!update")
//            if let path = indexPath,let cell = tableView.cellForRow(at: path) as? ProfitTableViewCell{
//                let p = fetchd.object(at: path)
//                cell.populate(p:p)
//            }
//        case .move:
//            print("!!move")
//            let sectionsInCoreData = fetchd.sections?.count ?? 0
//            let sectionInTable = tableView.numberOfSections
//            if sectionsInCoreData > sectionInTable{
//                sectionsChanged = true
//            }
//
//            if sectionsChanged {
//                tableView?.deleteRows(at: [indexPath].compactMap { $0 }, with: .fade)
//                tableView?.insertRows(at: [newIndexPath].compactMap { $0 }, with: .fade)
//                sectionsChanged = false
//            }
//        case .delete:
//            tableView.beginUpdates()
//            if numberOfObjectsInCurrentSection > 1 {
//                tableView.deleteRows(at: [indexPath!], with: .automatic)
//            } else {
//                let indexSet = NSMutableIndexSet()
//                indexSet.add(indexPath!.section)
//                tableView.deleteSections(indexSet as IndexSet, with: UITableView.RowAnimation.fade)
//            }
//
//            tableView.endUpdates()
//        default:
//            break
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//         switch type {
//             case .insert:
//                 tableView.insertSections(
//                     NSIndexSet(index: sectionIndex) as IndexSet,
//                     with: .fade)
//             case .delete:
//                 tableView.deleteSections(
//                     NSIndexSet(index: sectionIndex) as IndexSet,
//                     with: .fade)
//             default:
//                 break
//         }
//
//         sectionsChanged = true
//     }
//
//     func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//         tableView.beginUpdates()
//     }
//
//     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//         tableView.endUpdates()
//     }
//}


