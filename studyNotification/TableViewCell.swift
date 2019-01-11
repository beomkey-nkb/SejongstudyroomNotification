//
//  TableViewCell.swift
//  studyNotification
//
//  Created by 남기범 on 11/01/2019.
//  Copyright © 2019 남기범. All rights reserved.
//

import UIKit
import MBCircularProgressBar

//커스텀셀을 위해 만든 클래스
class TableViewCell: UITableViewCell {

    @IBOutlet weak var Room: UILabel!
    @IBOutlet weak var allSeatLabel: UILabel!
    @IBOutlet weak var allSeat: UILabel!
    @IBOutlet weak var extraSeatLabel: UILabel!
    @IBOutlet weak var extraSeat: UILabel!
    @IBOutlet weak var pie: MBCircularProgressBarView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
