//
//  EmbeddedListCell.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class EmbeddedListCell: UICollectionViewCell {
    @IBOutlet var mainImageView: NetworkImageView!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainImageView.layer.cornerRadius = 5
        mainImageView.layer.masksToBounds = true
    }
}
