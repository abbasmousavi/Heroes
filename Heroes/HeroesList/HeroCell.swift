//
//  HeroCell.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

protocol HeroCellProtocol: class {
    func isFavorite(_ hero: Hero) -> Bool
    func addFavorite(_ hero: Hero)
    func removeFavorite(_ hero: Hero)
}

class HeroCell: UITableViewCell {

    @IBOutlet private weak var favoriteButton: FavoriteButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainImageView: NetworkImageView!
    private var hero: Hero?
    weak var delegate: HeroCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 5
        mainImageView.layer.masksToBounds = true
    }

    func configure(hero: Hero) {

        self.hero = hero
        if let url = hero.thumbnail.thumbnailURL {
            mainImageView.setURL(url: url)
        }
        titleLabel?.text = hero.name
        if delegate?.isFavorite(hero) == true {
            favoriteButton.isFavorite = true
        }
    }

    override func prepareForReuse() {
        mainImageView.image = nil
        favoriteButton.isFavorite = false
    }

    @IBAction func toggleFavorite(_ sender: Any) {

        if favoriteButton.isFavorite {
            delegate?.removeFavorite(hero!)
            favoriteButton.isFavorite = false
        } else {
            delegate?.addFavorite(hero!)
            favoriteButton.isFavorite = true
        }
    }
}

extension HeroCell: SourceOfAnimatedTransition {
    func view() -> UIView {
        return mainImageView
    }
}
