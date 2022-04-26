//
//  HomeViewController.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 25/04/2022.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, RefreshTableProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var todos : [Todo]?
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewContext = appDelegate.persistentContainer.viewContext
        
        fetchTodos()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTodos(searchText: searchText)
    }
    
    func filterTodos(searchText: String) {
        
        if searchText == "" {
            fetchTodos()
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
    
    func fetchTodos(){
        do {
            todos = try viewContext.fetch(Todo.fetchRequest())
        } catch {
            print("Error fetching todos")
        }
    }
    
    @IBAction func filterDidChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            // get all
        case 0:
            fetchTodos()
            tableView.reloadData()
            // get high priority
        case 1:
            filterTodosPriority(filter: 1)
            // get medium priority
        case 2:
            filterTodosPriority(filter: 2)
            // get low priority
        case 3:
            filterTodosPriority(filter: 3)
        default:
            fetchTodos()
            tableView.reloadData()
        }
    }
    
    func filterTodosPriority(filter: Int) {
        
        var predicateFilter = "Low"
        
        switch filter {
        case 1:
            predicateFilter = "High"
        case 2:
            predicateFilter = "Medium"
        case 3:
            predicateFilter = "Low"
        default:
            predicateFilter = "Low"
        }
        
        if predicateFilter == "getAll" {
            fetchTodos()
        } else {
            do {
                let request = Todo.fetchRequest() as NSFetchRequest<Todo>
                let predicate = NSPredicate(format: "priority == %@", predicateFilter)
                request.predicate = predicate
                todos = try viewContext.fetch(request)
                tableView.reloadData()
                
            } catch {
                print("Error fetching todos")
            }
        }
        
    }
    
    func refreshTableAndApped(todo: Todo?) {
        todos?.append(todo!)
        tableView.reloadData()
    }
    
    func refreshTable() {
        tableView.reloadData()
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
    
}
