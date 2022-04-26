//
//  HomeViewController.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 25/04/2022.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RefreshTableProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todos : [Todo]?
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewContext = appDelegate.persistentContainer.viewContext
        
        fetchTodos()
        
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
