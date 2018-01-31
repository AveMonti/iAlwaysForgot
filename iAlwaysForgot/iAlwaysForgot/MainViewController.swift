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
}

