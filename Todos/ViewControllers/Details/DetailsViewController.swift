//
//  ViewController.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 25/04/2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UpdateTodoProtocol{
    
    var homeVCDelegate : RefreshTableProtocol?
    var todo : Todo?
    
    @IBOutlet weak var todoName: UILabel!
    @IBOutlet weak var todoDescription: UILabel!
    @IBOutlet weak var todoPriority: UIPickerView!
    
    var priorityPicked = "Low"
    
    var viewContext: NSManagedObjectContext!
    
    var priorityValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = todo?.name
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewContext = appDelegate.persistentContainer.viewContext
        
        priorityValues = ["Low", "Medium", "High"]
        todoPriority.delegate = self
        todoPriority.dataSource = self
        
        updateUI(todo: todo)
    }
    
    func updateUI(todo: Todo?){
        
        todoName.text = todo?.name
        todoDescription.text = todo?.details
        
        let priority = todo?.priority
        
        switch priority {
            case "Low":
                todoPriority.selectRow(0, inComponent: 0, animated: true)
            case "Medium":
                todoPriority.selectRow(1, inComponent: 0, animated: true)
            case "High":
                todoPriority.selectRow(2, inComponent: 0, animated: true)
            default:
                todoPriority.selectRow(0, inComponent: 0, animated: true)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorityValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        priorityPicked = priorityValues[row]
        return priorityValues[row]
    }

    func updateTodo(todo: Todo?) {
        updateUI(todo: todo)
        homeVCDelegate?.refreshTable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let todo = todo
        let editVC = segue.destination as! EditViewController
        editVC.todo = todo
        editVC.detailsVCDelegate = self
    }
    
}

