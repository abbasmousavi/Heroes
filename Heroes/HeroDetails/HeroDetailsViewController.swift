//
//  HeroDetailsViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class HeroDetailsViewController: UIViewController {

    let hero: Hero
    let service: Services

    init(service: Services, hero: Hero) {
        self.hero = hero
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet weak var mainImage: NetworkImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: FavoriteButton!
    @IBOutlet weak var storiesView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var comicsView: UIView!
    @IBOutlet weak var seriesView: UIView!

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = hero.thumbnail.thumbnailURL {
            mainImage?.setURL(url: url)
        }
        
        favoriteButton.isFavorite = service.store.isInStore(hero)

        titleLabel?.text = hero.name
        descriptionLabel?.text = hero.description.count > 0 ? hero.description : "No description available"

        let comics = EmbeddedListViewController<Comic>(service: service, uri: hero.comics.collectionURI!, title: "Comics")
        addChild(comics, in: comicsView)

        let series = EmbeddedListViewController<Comic>(service: service, uri: hero.series.collectionURI!, title: "Series")
        addChild(series, in: seriesView)

        let events = EmbeddedListViewController<Comic>(service: service, uri: hero.events.collectionURI!, title: "Events")
        addChild(events, in: eventsView)

        let stories = EmbeddedListViewController<Comic>(service: service, uri: hero.stories.collectionURI, title: "Stories")
        addChild(stories, in: storiesView)

    }

    @IBAction func toggleFavorite(_ sender: Any) {
        
        if favoriteButton.isFavorite {
            service.store.save(hero)
            favoriteButton.isFavorite = false
        } else {
             service.store.remove(hero)
            favoriteButton.isFavorite = true
        }
        
    }
}
