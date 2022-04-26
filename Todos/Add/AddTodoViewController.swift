//
//  AddTodoViewController.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 25/04/2022.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var homeVCDelegate : RefreshTableProtocol?
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var priority: UIPickerView!
    
    var priorityPicked = "Low"
    
    var viewContext: NSManagedObjectContext!
    
    var priorityValues = [String]()
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        saveTodo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewContext = appDelegate.persistentContainer.viewContext
        
        priorityValues = ["Low", "Medium", "High"]
        priority.delegate = self
        priority.dataSource = self

    }
    
    func saveTodo(){
        
        let todo = Todo(context: viewContext)
        todo.name = nameInput.text
        todo.details = descriptionInput.text
        todo.priority = priorityPicked
        
        do {
            try viewContext.save()
            homeVCDelegate?.refreshTableAndApped(todo: todo)
            navigationController?.popViewController(animated: true)
            print("todo saved with name: \(nameInput.text)")
            print("todo saved with description: \(descriptionInput.text)")
            print("todo saved with priority: \(priorityPicked)")
        } catch {
            print("Error saving movie")
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
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
