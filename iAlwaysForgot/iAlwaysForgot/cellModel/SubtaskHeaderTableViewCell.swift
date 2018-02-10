//
//  SubtaskHeaderTableViewCell.swift
//  iAlwaysForgot
//
//  Created by Mateusz Chojnacki on 2/10/18.
//  Copyright © 2018 Mateusz Chojnacki. All rights reserved.
//

import UIKit
protocol SubTaskHeaderCellButtonDelegae {
    func addButtonPressed()
}
class SubtaskHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var toDoCountLabel: UILabel!
    @IBOutlet weak var doneCountLabel: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var addBtnOutlet: UIButton!
    
    
    var delegate:SubTaskHeaderCellButtonDelegae? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButton(_ sender: Any) {
        delegate?.addButtonPressed()
    }
}
