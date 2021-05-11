//
//  MainChannelCollectionViewCell.swift
//  UrlExtractor
//
//  Created by Panchami Rao on 05/05/21.
//

import UIKit

protocol MainChannelCollectionViewCellDelegate {
    func listButtonClicked(_ indexpath: IndexPath)
}

class MainChannelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var listButton: UIButton!
    
    var delegate: MainChannelCollectionViewCellDelegate?
    var indexpath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func listButtonClicked(_ sender: UIButton) {
        if let indexpath = indexpath {
            delegate?.listButtonClicked(indexpath)
        }
    }
}

