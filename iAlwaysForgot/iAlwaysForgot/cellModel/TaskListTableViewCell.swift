//
//  TaskListTableViewCell.swift
//  iAlwaysForgot
//
//  Created by Mateusz Chojnacki on 01.02.2018.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var TaskListCountLabel: UILabel!
    @IBOutlet weak var TaskListTitleLabel: UILabel!
    @IBOutlet weak var CounterTaskInsideLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
