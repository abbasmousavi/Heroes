//
//  HeroDetailsViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class HeroDetailsViewController: UIViewController {
    @IBOutlet private var mainImage: NetworkImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var favoriteButton: FavoriteButton!
    @IBOutlet private var storiesView: UIView!
    @IBOutlet private var eventsView: UIView!
    @IBOutlet private var comicsView: UIView!
    @IBOutlet private var seriesView: UIView!
    private let hero: Hero
    private let service: Services

    init(service: Services, hero: Hero) {
        self.hero = hero
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func dismiss(_: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = hero.thumbnail.thumbnailURL {
            mainImage?.setURL(url: url)
        }

        favoriteButton.isFavorite = service.store.isInStore(hero)

        titleLabel?.text = hero.name
        descriptionLabel?.text = hero.description.count > 0 ? hero.description : "No description available"

        let comics = EmbeddedListViewController<Comic>(service: service, uri: hero.comics.collectionURI, title: "Comics")
        addChild(comics, in: comicsView)

        let series = EmbeddedListViewController<Serie>(service: service, uri: hero.series.collectionURI, title: "Series")
        addChild(series, in: seriesView)

        let events = EmbeddedListViewController<Event>(service: service, uri: hero.events.collectionURI, title: "Events")
        addChild(events, in: eventsView)

        let stories = EmbeddedListViewController<Story>(service: service, uri: hero.stories.collectionURI, title: "Stories")
        addChild(stories, in: storiesView)
    }

    @IBAction func toggleFavorite(_: Any) {
        if favoriteButton.isFavorite {
            service.store.remove(hero)
            favoriteButton.isFavorite = false
        } else {
            service.store.save(hero)
            favoriteButton.isFavorite = true
        }
    }
}

extension HeroDetailsViewController: SourceOfAnimatedTransition {
    func sourceView() -> UIView {
        return mainImage
    }
}

extension HeroDetailsViewController: DestinationOfAnimatedTransition {
    func destinationView() -> UIView {
        return mainImage
    }
}
