//
//  HeroCell.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

protocol HeroCellProtocol: class {
    func isFavorite(hero: Hero) -> Bool
    func addFavorite(hero: Hero)
    func removeFavorite(hero: Hero)
}

class HeroCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: FavoriteButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: NetworkImageView!
    weak var delegate: HeroCellProtocol?
    private var hero: Hero?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainImageView.layer.cornerRadius = 5
        mainImageView.layer.masksToBounds = true
    }
    
    func configure(hero: Hero) {
        
        self.hero = hero
        if let url = hero.thumbnail.thumbnailURL {
        mainImageView.setURL(url: url)
        }
        
        titleLabel?.text = hero.name
        if delegate?.isFavorite(hero: hero) == true {
            favoriteButton.isFavorite = true
        }
    }
    
    override func prepareForReuse() {
        mainImageView.image = nil
        favoriteButton.isFavorite = false
    }

    @IBAction func toggleFavorite(_ sender: Any) {
        
        if favoriteButton.isFavorite {
            delegate?.removeFavorite(hero: hero!)
            favoriteButton.isFavorite = false
        } else {
            delegate?.addFavorite(hero: hero!)
            favoriteButton.isFavorite = true
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
