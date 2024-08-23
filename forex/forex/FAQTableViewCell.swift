//
//  FAQTableViewCell.swift
//  zaimyfinansov1
//
//  Created by msklv on 13.06.24.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var dep: UILabel!
    
    @IBOutlet weak var namee: UILabel!
    @IBOutlet weak var butt: UIButton!
    
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var iiimage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
