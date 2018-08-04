//
//  EmbeddedListViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EmbeddedListCell"

class EmbeddedListViewController < T: Codable & Listable >: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let uri: String
    private var items = [T]()
    private let service: Services

    @IBOutlet weak var stateIndicator: StateIndicator!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(service: Services, uri: String, title: String) {
        self.uri = uri
        self.service = service
        super.init(nibName: "EmbeddedListViewController", bundle: nil)
        self.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        titleLabel?.text = title
        loadData()
    }

    func loadData() {
        stateIndicator.startLoading()
        service.request(uri: uri) { (result: Result<T>) in
            self.items = result.value!.data.results

            if (self.items.count > 0) {
                self.stateIndicator.stopLoading()
                self.collectionView.reloadData()
            } else {
                self.stateIndicator.stopLoading(message: "No items available")
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? EmbeddedListCell
        
        if let url = items[indexPath.row].thumbnail?.thumbnailURL {
            cell?.mainImageView?.image = UIImage(named: "loading")
            cell?.mainImageView?.setURL(url: url)
        }
        cell?.titleLabel?.text = items[indexPath.row].title
        return cell!
    }
}
