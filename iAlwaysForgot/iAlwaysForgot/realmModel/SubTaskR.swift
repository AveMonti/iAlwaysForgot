//
//  SubTaskR.swift
//  iAlwaysForgot
//
//  Created by Mateusz Chojnacki on 31.01.2018.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import Foundation
import RealmSwift

class SubTaskR: Object {
    @objc dynamic var taskName = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var remaindUID = ""
    @objc dynamic var remaindData:Date?
    
    convenience init(taskName: String, isDone: Bool) {
        self.init()
        self.taskName = taskName
        self.isDone = isDone
        self.remaindUID = ""
    }
}
