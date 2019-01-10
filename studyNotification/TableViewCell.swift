//
//  TableViewCell.swift
//  studyNotification
//
//  Created by 남기범 on 11/01/2019.
//  Copyright © 2019 남기범. All rights reserved.
//

import UIKit

//커스텀셀을 위해 만든 클래스
class TableViewCell: UITableViewCell {

    @IBOutlet weak var Room: UILabel!
    @IBOutlet weak var useNumber: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
