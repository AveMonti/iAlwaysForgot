//
//  SubTaskListTableViewCell.swift
//  iAlwaysForgot
//
//  Created by Mateusz Chojnacki on 2/2/18.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import UIKit
protocol SubTaskCellButtonDelegae {
    func buttonPressed(selfCell: SubTaskListTableViewCell)
}

class SubTaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var subTaskTitleLabel: UILabel!
    @IBOutlet weak var yearDateLabel: UILabel!
    @IBOutlet weak var hoursDateLabel: UILabel!
    
    
    var currentIndex:Int?
     var delegate: SubTaskCellButtonDelegae? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func addDateButton(_ sender: Any) {
        delegate?.buttonPressed(selfCell: self)
    }
    
}
