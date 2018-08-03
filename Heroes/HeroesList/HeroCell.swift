//
//  HeroCell.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class HeroCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: NetworkImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainImageView.layer.cornerRadius = 5
        mainImageView.layer.masksToBounds = true
    }
    
    func configure(hero: Hero) {
        
        if let url = hero.thumbnail.thumbnailURL {
        mainImageView.setURL(url: url)
        }
        
        titleLabel?.text = hero.name
    }
    
    override func prepareForReuse() {
        mainImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
