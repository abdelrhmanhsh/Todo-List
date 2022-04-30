//
//  EditViewController.swift
//  Todos
//
//  Created by Abdelrhman Ahmed on 25/04/2022.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var detailsVCDelegate : UpdateTodoProtocol?
    var todo : Todo?

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var priority: UIPickerView!
    
    var priorityPicked = "Low"
    
    var viewContext: NSManagedObjectContext!
    
    var priorityValues = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewContext = appDelegate.persistentContainer.viewContext
        
        priorityValues = ["Low", "Medium", "High"]
        priority.delegate = self
        priority.dataSource = self

        updateUI(todo: todo)
    }
    
    func updateUI(todo: Todo?){
        
        nameInput.text = todo?.name
        descriptionInput.text = todo?.details
        
        switch todo?.priority {
            case "Low":
                priority.selectRow(0, inComponent: 0, animated: true)
            case "Medium":
                priority.selectRow(1, inComponent: 0, animated: true)
            case "High":
                priority.selectRow(2, inComponent: 0, animated: true)
            default:
                priority.selectRow(0, inComponent: 0, animated: true)
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
    
    @IBAction func btnDone(_ sender: UIBarButtonItem) {
        
        todo?.name = nameInput.text
        todo?.details = descriptionInput.text
        todo?.priority = priorityPicked
        
        do {
            try self.viewContext.save()
        }
        catch {
            print("Error updating todo")
        }
        
        detailsVCDelegate?.updateTodo(todo: todo)
        navigationController?.popViewController(animated: true)
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
