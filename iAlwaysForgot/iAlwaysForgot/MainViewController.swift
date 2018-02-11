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
        tableView.backgroundColor = .clear
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
        let modifyAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
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
        
        
        let alert = UIAlertController(title: "New task list", message: "Add the name of your task list ", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
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
                textField.placeholder = "Add your tasks list"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell") as! TaskListTableViewCell
        cell.TaskListCountLabel.text = "\(indexPath.row)."
        cell.TaskListTitleLabel.text = realm.getAll()[indexPath.row].nameTaskList
        cell.CounterTaskInsideLabel.text = "\(realm.getAll()[indexPath.row].subTaskList.count) tasks"
        
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 3
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = UITableViewCellSelectionStyle.none
        let detailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailsVC") as! SubTasksViewController
        detailsVC.subTasks = realm.getAll()[indexPath.row]
        show(detailsVC, sender: self)
    }
}

