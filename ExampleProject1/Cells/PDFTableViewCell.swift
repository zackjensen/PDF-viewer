//
//  PDFTableViewCell.swift
//  ExampleProject1
//
//  Created by Zachary Jensen on 1/15/21.
//

import UIKit

class PDFTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var uploadedAtLbl: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
