//
//  BasicUrlCell.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 15/04/21.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func viewWebPageButtonClicked(indexPath:IndexPath)
}

class BasicUrlCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var viewWebPageButton: UIButton!
    
    weak var delegate: TableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewWebPageButtonClicked(_ sender: UIButton) {
        if let indexPath = indexPath {
            delegate?.viewWebPageButtonClicked(indexPath: indexPath)
            
        }
    }
}
