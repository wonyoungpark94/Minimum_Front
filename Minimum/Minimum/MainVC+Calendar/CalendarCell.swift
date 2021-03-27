//
//  CalendarCell.swift
//  CalendarExampleTutorial
//
//  Created by CallumHill on 14/1/21.
//

import UIKit

class CalendarCell: UICollectionViewCell
{
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dayOfMonth: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: CalendarModel) {
        image.image = model.image
        label.text = model.label
    }
    

    override var isSelected: Bool {
        didSet{
            if isSelected {
                
            }
            else {
                
            }
        }
    }
}
