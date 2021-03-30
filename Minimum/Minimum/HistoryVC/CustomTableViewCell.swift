//
//  CustomTableViewCell.swift
//  Minimum
//
//  Created by park wonyoung on 2021/03/10.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var vc: HistoryViewController!
    
    @IBOutlet weak var galleryOutlet: UIButton!
    
    //이미지 버튼 눌렸을 때
    @IBAction func imageButtonTapped(_ sender: Any) {
        vc.showImage(cell: self);
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        //vc.deleteCellData(cell: self);
    }
    
    
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
