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
    
    init(hero: Hero) {
        self.hero = hero
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var storiesView: UIView!
    @IBOutlet weak var eventsView: UIView!
    @IBOutlet weak var comicsView: UIView!
    @IBOutlet weak var seriesView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = hero.thumbnail.thumbnailURL {
        mainImage?.setURL(url: url)
        }
        
        titleLabel?.text = hero.name
        descriptionLabel?.text = hero.description.count > 0 ? hero.description : "No description available"

        // Do any additional setup after loading the view.
        
        let comics = EmbeddedListViewController<Comic>(uri: hero.comics.collectionURI!, title: "Comics")
        addChild(comics, in: comicsView)

        
        let series = EmbeddedListViewController<Comic>(uri: hero.series.collectionURI!, title: "Series")
        addChild(series, in: seriesView)
        
        
        let events = EmbeddedListViewController<Comic>(uri: hero.events.collectionURI!, title: "Events")
        addChild(events, in: eventsView)
        
        let stories = EmbeddedListViewController<Comic>(uri: hero.stories.collectionURI, title: "Stories")
        addChild(stories, in: storiesView)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
