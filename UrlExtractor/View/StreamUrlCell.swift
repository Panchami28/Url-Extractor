//
//  StreamUrlCell.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 28/04/21.
//

import UIKit

protocol StreamUrlCellDelegate: AnyObject {
    func addToFavouritesButtonClicked(indexPath:IndexPath)
}


class StreamUrlCell: UITableViewCell {

    @IBOutlet weak var streamLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    
    weak var delegate: StreamUrlCellDelegate?
    var indexpath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func addToFavouritesButtonClicked(_ sender: UIButton) {
        if let indexpath = indexpath {
            delegate?.addToFavouritesButtonClicked(indexPath: indexpath)
        }
    }
    
}
