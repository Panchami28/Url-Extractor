//
//  StreamUrlCell.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 28/04/21.
//

import UIKit

protocol StreamUrlCellDelegate: AnyObject {
    func addToFavouritesButtonClicked(indexPath:IndexPath)
    func moreButtonClicked(indexPath:IndexPath)
}


class StreamUrlCell: UITableViewCell {

    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var streamLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
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
    
    @IBAction func moreButtonClicked(_ sender: UIButton) {
        if let indexpath = indexpath {
            delegate?.moreButtonClicked(indexPath: indexpath)
        }
    }
}
