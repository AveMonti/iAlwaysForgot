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
SubTaskCellButtonDelegae, SubTaskHeaderCellButtonDelegae {
    func addButtonPressed() {
        self.subTaskAction(index: nil)
    }
    
    
    var subtaskCellDelegate = SubTaskListTableViewCell()
    var progresCircle = ProgressCircle()
    
    @IBOutlet weak var tableVIew: UITableView!
    var realm = RealmService.shared
    var subTasks:TaskListR?
    var headerCell = SubtaskHeaderTableViewCell()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.yellow;
        self.navigationItem.title = "\((self.subTasks?.nameTaskList)!)"
        
        //Header Cell
        headerCell = tableVIew.dequeueReusableCell(withIdentifier: "subTaskHeaderCell") as! SubtaskHeaderTableViewCell
        progresCircle = ProgressCircle(view: headerCell.circleView)
        progresCircle.setup()
        let randomNum:UInt32 = arc4random_uniform(5)
        headerCell.bgImage.loadGif(name: "space\(randomNum)")
        headerCell.addBtnOutlet.layer.cornerRadius = 0.5 * headerCell.addBtnOutlet.bounds.size.height
        headerCell.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
        
        tableVIew.backgroundColor = .clear

        self.updateUI()
        
    }
    
    func buttonPressed(selfCell: SubTaskListTableViewCell){
        let picker = UIDatePicker()
        let alertVC = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n", message: "", preferredStyle: .actionSheet);
        let action = UIAlertAction(title: "Set", style: .default) { (alertAction) in
            
            if(self.subTasks?.subTaskList[selfCell.currentIndex!].remaindUID != ""){
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(self.subTasks?.subTaskList[selfCell.currentIndex!].remaindUID)!])
                
            }
            
            self.timedNotifications(date: picker.date,index: selfCell.currentIndex!) { (success) in
                if success {
                    print("Notyfication was added")
                }
            }
            self.realm.updateReminderDate(taskList: self.subTasks!, index: selfCell.currentIndex!, remainderDate: picker.date)
            self.updateUI()
        }
        
        let deleteNotyfication = UIAlertAction(title: "Delete notyfication", style: .destructive) { (alertAction) in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(self.subTasks?.subTaskList[selfCell.currentIndex!].remaindUID)!])
            
            self.realm.updateReminderUID(taskList: self.subTasks!, index: selfCell.currentIndex!, remaindUID: "")
            self.updateUI()
        }
        
        if(self.subTasks?.subTaskList[selfCell.currentIndex!].remaindUID != ""){
            alertVC.addAction(deleteNotyfication)
        }
        
        alertVC.addAction(action)
        alertVC.isModalInPopover = true;
        alertVC.view.addSubview(picker)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

        self.present(alertVC, animated: true, completion: nil)
    }
    
    func timedNotifications(date: Date,index: Int, completion: @escaping (_ Success: Bool) -> ()) {
        
        let content = UNMutableNotificationContent()
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                    repeats: false)
        content.title = "Hey u have task to do."
        
        content.body = (subTasks?.subTaskList[index].taskName)!
        
        guard let path = Bundle.main.path(forResource: "doit", ofType: "gif") else {return}
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachments = try [UNNotificationAttachment(identifier: "logo2", url: url, options: nil)]
            content.attachments = attachments
        } catch{
            print("Error")
        }
//
//        guard let path = Bundle.main.path(forResource: "Apple", ofType: "png") else {return}
//        let url = URL(fileURLWithPath: path)
//
//        do {
//            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
//            content.attachments = [attachment]
//        }catch{
//            print("The attachment could not be loaded")
//        }
        
        
        //
        let identifier = UUID().uuidString
        self.realm.updateReminderUID(taskList: self.subTasks!, index: index, remaindUID: identifier)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            
            if error != nil {
                completion(false)
            }else {
                completion(true)
            }
        }
        
    }
    
    func escaping(){
        print("Error")
    }
    
    
    func subTaskAction(index: Int?){
        let alert = UIAlertController(title: "Add new task", message: "Enter the name of the task", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if(index != nil){
                self.realm.updateSubTask(taskList: self.subTasks!, index: index!, subTaskTitle: textField.text!, isDone: nil)
            }else{
                let newSubtask = SubTaskR(taskName: textField.text!, isDone: false)
                self.realm.addSubTask(taskList: self.subTasks!, subTask: newSubtask)
            }
            self.updateUI()
            
        }
        alert.addTextField { (textField) in
            if(index != nil){
                textField.placeholder = self.subTasks?.subTaskList[index!].taskName
            }else{
                textField.placeholder = "Do what you can't!"
            }
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUI(){
        self.tableVIew.reloadData()
        var countDone = 0
        for value in (self.subTasks?.subTaskList)!{
            if value.isDone == true{
                countDone = countDone + 1
            }
        }

        let allTasks = Float((self.subTasks?.subTaskList.count)!)
        self.headerCell.toDoCountLabel.text! = "ToDo: \(Int(allTasks) - countDone)"
        self.headerCell.doneCountLabel.text = "Done: \(countDone)"
        self.progresCircle.update(currentValue: Float((Float(countDone) / allTasks)) * 0.8)
    }
    
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
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let modifyAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.subTaskAction(index: indexPath.row)
            success(true)
        })
        modifyAction.image = UIImage(named: "hammer")
        modifyAction.backgroundColor = .purple
        
        
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [(self.subTasks?.subTaskList[indexPath.row].remaindUID)!])
            self.realm.updateReminderUID(taskList: self.subTasks!, index: indexPath.row, remaindUID: "")
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
        cell.subTaskTitleLabel.text = " - \((self.subTasks?.subTaskList[indexPath.row].taskName)!)"
        if(self.subTasks?.subTaskList[indexPath.row].remaindUID != ""){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            var nssDate = dateFormatter.string(from: (self.subTasks?.subTaskList[indexPath.row].remaindData)!)
            cell.yearDateLabel.text = nssDate
            dateFormatter.dateFormat = "HH:mm"
            nssDate = dateFormatter.string(from: (self.subTasks?.subTaskList[indexPath.row].remaindData)!)
            cell.hoursDateLabel.text = nssDate
        }else{
            cell.hoursDateLabel.text = ""
            cell.yearDateLabel.text = ""
        }
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 240
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
}
