//
//  ViewController.swift
//  iAlwaysForgot
//
//  Created by Mateusz Chojnacki on 31.01.2018.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var realm = RealmService.shared
    @IBOutlet weak var tableView: UITableView!
    
    // UI
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addTaskList(_ sender: Any) {
        self.displayAlert(currentTask: nil)
    }
    
    func updateUI(){
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.displayAlert(currentTask: self.realm.getAll()[indexPath.row])
            success(true)
        })
        modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .purple
        
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.realm.delete(taskList: self.realm.getAll()[indexPath.row])
            self.updateUI()
            success(true)
        })
        deleteAction.image = UIImage(named: "hammer")
        deleteAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [deleteAction,modifyAction])
    }
    
    
    func displayAlert(currentTask: TaskListR?){
        
        
        let alert = UIAlertController(title: "Great Title", message: "Please input something", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Name Input", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if (currentTask != nil){
                
                self.realm.update(taskList: currentTask!, taskListName: textField.text!)
                self.updateUI()
            }else{
                
                let newTask = TaskListR(nameTaskList: textField.text!)//TaskListR(taskName: textField.text!, done: false)
                self.realm.create(taskList: newTask)
                self.updateUI()
            }
        }
        alert.addTextField { (textField) in
            if(currentTask != nil){
                textField.placeholder = currentTask?.nameTaskList
            }else{
                textField.placeholder = "Enter your name"
            }
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.getAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "taskListCell")
        
        cell.textLabel?.text = realm.getAll()[indexPath.row].nameTaskList
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as! SubTasksViewController
        detailsVC.subTasks = realm.getAll()[indexPath.row]
        show(detailsVC, sender: self)
    }
}

