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
    
    @IBOutlet weak var seriesView: UIView!
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var mainImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: hero.thumbnail.path + "." + (hero.thumbnail.pathExtension))
        
        mainImage?.image = UIImage(named: "loading")
        mainImage?.setURL(url: url!)

        // Do any additional setup after loading the view.
        
        let comics = EmbeddedListViewController<Comic>(uri: hero.comics.collectionURI!)
        addChild(comics)
        seriesView.addSubview(comics.view)
        comics.view.translatesAutoresizingMaskIntoConstraints = false
        comics.view.topAnchor.constraint(equalTo: seriesView.topAnchor).isActive = true
        comics.view.bottomAnchor.constraint(equalTo: seriesView.bottomAnchor).isActive = true
        comics.view.leadingAnchor.constraint(equalTo: seriesView.leadingAnchor).isActive = true
        comics.view.trailingAnchor.constraint(equalTo: seriesView.trailingAnchor).isActive = true
        
        comics.didMove(toParent: self)
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
