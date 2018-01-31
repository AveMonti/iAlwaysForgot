//
//  TaskListR.swift
//  iAlwaysForgot
//
//  Created by Mateusz Chojnacki on 31.01.2018.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import Foundation
import RealmSwift

class TaskListR : Object{
    @objc dynamic var nameTaskList = ""
    let subTaskList = List<SubTaskR>()
    
    convenience init(nameTaskList: String) {
        self.init()
        self.nameTaskList = nameTaskList;
    }
    
}
