//
//  FavoriteButton.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/4/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var isFavorite: Bool = false {
        didSet{
            if isFavorite {
                 self.setImage(UIImage(named: "fav-active"), for: .normal)
            } else {
                self.setImage(UIImage(named: "fav-inactive"), for: .normal)
            }
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isFavorite = false
    }

}
