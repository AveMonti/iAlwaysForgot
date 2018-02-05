//
//  SubTasksViewController.swift
//  iAlwaysForgot
//
//  Created by Mateusz Chojnacki on 2/1/18.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import UIKit
import UserNotifications

class SubTasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, 
SubTaskCellButtonDelegae {
    
    let subtaskCellDelegate = SubTaskListTableViewCell()
    
    
    
    @IBOutlet weak var tableVIew: UITableView!
    var realm = RealmService.shared
    var subTasks:TaskListR?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
        
        
    }
    
    func buttonPressed(selfCell: SubTaskListTableViewCell){
        print(selfCell)
        //TODO: Add data picker on UIAlertController
        let picker = UIDatePicker()
        
        let alertVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .actionSheet);
        let action = UIAlertAction(title: "Set", style: .default) { (alertAction) in
            
            
            self.timedNotifications(date: picker.date,index: selfCell.currentIndex!) { (success) in
                if success {
                    print("Notyfication was added")
                }
            }
            print("date \(picker.date)")
            self.realm.updateReminderDate(taskList: self.subTasks!, index: selfCell.currentIndex!, remainderDate: picker.date)
            print("loooooool \(self.subTasks?.subTaskList[selfCell.currentIndex!].reminderDate)")
            
            
        }
        
        alertVC.addAction(action)
        alertVC.isModalInPopover = true;
        alertVC.view.addSubview(picker)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    
    
    func timedNotifications(date: Date,index: Int, completion: @escaping (_ Success: Bool) -> ()) {
        
       // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        let content = UNMutableNotificationContent()
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        
        
        
        
        content.title = "Hey u have task to do"
        content.subtitle = "do more"
        content.body = (subTasks?.subTaskList[index].taskName)!
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            
            if error != nil {
                completion(false)
            }else {
                completion(true)
            }
        }
        
    }
    
    func escaping(){
        print("xD")
    }
    
    
    
  
    
    @IBAction func addBTN(_ sender: Any) {
        self.subTaskAction(index: nil)
    }
    
    func subTaskAction(index: Int?){
        let alert = UIAlertController(title: "Great Title", message: "Please input something", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Name Input", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if(index != nil){
                self.realm.updateSubTask(taskList: self.subTasks!, index: index!, subTaskTitle: textField.text!, isDone: nil)
            }else{
                let newSubtask = SubTaskR(taskName: textField.text!, isDone: false)
                self.realm.addSubTask(taskList: self.subTasks!, subTask: newSubtask) //(taskList: self.tasker!, subTask: newSubtask)
            }
            self.updateUI()
            
        }
        alert.addTextField { (textField) in
            
            
            
            if(index != nil){
                textField.placeholder = self.subTasks?.subTaskList[index!].taskName
            }else{
                textField.placeholder = "Enter your name"
            }
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUI(){
        self.tableVIew.reloadData()
    }
    
   
    // table view
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let title:String
        let color:UIColor
        let isAllreadyDone = self.subTasks?.subTaskList[indexPath.row].isDone
        if(isAllreadyDone != false){
            title = "Not Yet"
            color = UIColor.red
        }else{
            title = "Done"
            color = UIColor.green
        }
        
        let closeAction = UIContextualAction(style: .normal, title:  title , handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let isDone = self.subTasks?.subTaskList[indexPath.row].isDone
            
            self.realm.updateSubTask(taskList: self.subTasks!, index: indexPath.row, subTaskTitle: nil, isDone: !isDone!)
            self.updateUI()
            success(true)
        })
        closeAction.image = UIImage(named: "tick")
        closeAction.backgroundColor = color
        
        return UISwipeActionsConfiguration(actions: [closeAction])
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        
        let modifyAction = UIContextualAction(style: .normal, title:  "Update", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.subTaskAction(index: indexPath.row)
            success(true)
        })
        modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .purple
        
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.realm.deleteSubTask(taskList: self.subTasks!, index: indexPath.row)
            self.updateUI()
            success(true)
        })
        deleteAction.image = UIImage(named: "hammer")
        deleteAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [deleteAction,modifyAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return (subTasks?.subTaskList.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subTaskCell") as! SubTaskListTableViewCell
        
        
        cell.currentIndex = indexPath.row
        cell.subTaskTitleLabel.text = self.subTasks?.subTaskList[indexPath.row].taskName
        
        
        //Remainding date Year
//
//        let dateFormatter = DateFormatter()
//        let nssDate = dateFormatter.string(from: (self.subTasks?.subTaskList[indexPath.row].reminderDate)!)
//        cell.yearDateLabel.text = nssDate
        print(self.subTasks?.subTaskList[indexPath.row].reminderDate)

        
        
        
        //SubTaskTitle
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell.subTaskTitleLabel.text)!)
        if(subTasks?.subTaskList[indexPath.row].isDone == true){
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        }else{
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 0, range: NSMakeRange(0, attributeString.length))
        }
        cell.subTaskTitleLabel?.attributedText = attributeString
        
        cell.delegate = self
        
        return cell
    }
    
}
