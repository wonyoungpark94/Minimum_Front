//
//  CustomTableViewCell.swift
//  Minimum
//
//  Created by park wonyoung on 2021/03/10.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var galleryButton: UIButton!
    
    
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var changedDaysLabel: UILabel!
    @IBOutlet weak var changedWeightLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}
