//
//  RealmService.swift
//  iAlwaysForgot
//
//  Created by Mateusz Chojnacki on 31.01.2018.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService{
    private init(){} //singletone
    static let shared = RealmService()
    
    var realm = try! Realm()
    
    // TaskList
    
    func getAll() -> [TaskListR] {
        let resoults: Results<TaskListR> = realm.objects(TaskListR.self)
        return Array(resoults)
    }
    
    func update(taskList: TaskListR, taskListName: String?){
        do{
            try realm.write {
                if(taskListName != nil){
                    taskList.nameTaskList = taskListName!
                }
            }
        }catch let error as NSError {
            post(error)
        }
    }
    
    func delete(taskList: TaskListR) {
        do {
            try realm.write {
                realm.delete(taskList)
            }
        } catch let error as NSError {
            post(error)
        }
    }
    
    func create(taskList: TaskListR){
        do{
            try realm.write {
                realm.add(taskList)
            }
        } catch let error as NSError {
            post(error)
        }
    }
    
    // SubTask
    
    func addSubTask(taskList: TaskListR, subTask: SubTaskR){
        do{
            try realm.write {
                taskList.subTaskList.append(subTask)
            }
        } catch let error as NSError{
            post(error)
        }
    }
    
    func deleteSubTask(taskList: TaskListR, index: Int){
        do{
            try realm.write {
                taskList.subTaskList.remove(at: index)
            }
            
        } catch let error as NSError{
            post(error)
        }
    }
    
    func updateSubTask(taskList: TaskListR, index : Int, subTaskTitle: String?, isDone: Bool?){
        do{
            try realm.write {
                if(subTaskTitle != nil){
                    taskList.subTaskList[index].taskName = subTaskTitle!
                }
                if(isDone != nil){
                    taskList.subTaskList[index].isDone = isDone!
                }
                
            }
            
        } catch let e as NSError {
            post(e)
        }
    }
    
    func updateReminderUID(taskList: TaskListR, index : Int, remaindUID: String){
        do{
            try realm.write {
                taskList.subTaskList[index].remaindUID = remaindUID
            }
            
        } catch let e as NSError{
            post(e)
        }
    }
    
        func updateReminderDate(taskList: TaskListR, index : Int, remainderDate: Date){
            do{
                try realm.write {
                    taskList.subTaskList[index].remaindData = remainderDate
                }
    
            } catch let e as NSError{
                post(e)
            }
        }
    
    /// Notyfication Center
    func post(_ error: Error){
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
}
