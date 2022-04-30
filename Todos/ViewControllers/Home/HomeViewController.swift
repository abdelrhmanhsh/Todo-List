//
//  HomeViewController.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 25/04/2022.
//

import UIKit
import CoreData
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, RefreshTableProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
    @IBOutlet weak var sortSwitch: UISwitch!
    var todos : [Todo]?
    var viewContext: NSManagedObjectContext!
    
    let userDefauls = UserDefaultManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewContext = appDelegate.persistentContainer.viewContext
        
        getTodos()
        
        self.navigationItem.hidesBackButton = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = todos?[indexPath.row].name
        cell.textLabel!.text = name
        
        let priority = todos?[indexPath.row].priority
        switch priority {
        case "Low":
            cell.imageView?.image = UIImage(named: "low.png")
        case "Medium":
            cell.imageView?.image = UIImage(named: "medium.png")
        case "High":
            cell.imageView?.image = UIImage(named: "high.png")
        default:
            cell.imageView?.image = UIImage(named: "low.png")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            print("deleting \(todos![indexPath.row].name)")
            
            viewContext.delete(todos![indexPath.row])
            
            do {
                try viewContext.save()
                todos?.remove(at: indexPath.row)
            } catch {
                print("Error deleting todo")
            }
            
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
    }
    
    func getTodos(){
        
        // filter todos
        let filter = userDefauls.getFilter()
        filterSegmentControl.selectedSegmentIndex = filter
        
        // sort todos
        let isSort = userDefauls.getIfSort()
        sortSwitch.isOn = isSort
        
        fetchTodos(filter: filter, sort: isSort)
        
    }
    
    func fetchAllTodos(){
        do {
            todos = try viewContext.fetch(Todo.fetchRequest())
        } catch {
            print("Error fetching todos")
        }
    }
    
    func filterTodos(searchText: String) {
        
        if searchText == "" {
            fetchAllTodos()
            tableView.reloadData()
        } else {
            do {
                let request = Todo.fetchRequest() as NSFetchRequest<Todo>
                let predicate = NSPredicate(format: "name == %@", searchText)
                request.predicate = predicate
                todos = try viewContext.fetch(request)
                tableView.reloadData()
                
            } catch {
                print("Error fetching todos")
            }
        }
        
    }
    
    @IBAction func filterDidChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0: // get all
            userDefauls.saveFilter(filter: 0)
            
        case 1: // get high priority
            userDefauls.saveFilter(filter: 1)
            
        case 2: // get medium priority
            userDefauls.saveFilter(filter: 2)
            
        case 3: // get low priority
            userDefauls.saveFilter(filter: 3)
            
        default:
            userDefauls.saveFilter(filter: 0)
        }
        getTodos()
    }
    
    func fetchTodos(filter: Int, sort: Bool){
        
        var predicateFilter = "All"
        
        switch filter {
        case 0:
            predicateFilter = "All"
        case 1:
            predicateFilter = "High"
        case 2:
            predicateFilter = "Medium"
        case 3:
            predicateFilter = "Low"
        default:
            predicateFilter = "All"
        }
        
        do {
            
            let request = Todo.fetchRequest() as NSFetchRequest<Todo>
            if predicateFilter == "All" {
                todos = try viewContext.fetch(Todo.fetchRequest())
                tableView.reloadData()
            } else {
                let predicate = NSPredicate(format: "priority == %@", predicateFilter)
                request.predicate = predicate
            }
            
            let alphabeticSort = NSSortDescriptor(key: "name", ascending: sort)
            request.sortDescriptors = [alphabeticSort]
            
            todos = try viewContext.fetch(request)
            tableView.reloadData()
            
        } catch {
            print("Error fetching todos")
        }
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            // Sort Alphabetically
            userDefauls.saveIfSort(sort: true)
            
        } else {
            userDefauls.saveIfSort(sort: false)
        }
        
        getTodos()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTodos(searchText: searchText)
    }
   
    @IBAction func btnLogout(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            userDefauls.saveUserLoggedIn(loggedIn: false)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Error logging out")
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAddTodoSegue"{
            
            let addTodoVC = segue.destination as! AddTodoViewController
            addTodoVC.homeVCDelegate = self
            
        } else if segue.identifier == "goToDetailsSegue" {
            
            let todo = todos?[self.tableView.indexPathForSelectedRow!.row]
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.todo = todo
            detailsVC.homeVCDelegate = self
            
        }
    }
    
    // MARK: Delegates
    
    func refreshTableAndApped(todo: Todo?) {
        todos?.append(todo!)
        tableView.reloadData()
    }
    
    func refreshTable() {
        tableView.reloadData()
    }
}
