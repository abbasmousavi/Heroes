//
//  HeroListTableViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/5/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

//protocol HeroListControllerProtocol {
//
//    func isFavorite(_ hero: Hero) -> Bool
//    func addFavorite(_ hero: Hero)
//    func removeFavorite(_ hero: Hero)
//}

class HeroListController: UITableViewController {
    
    private let paginationLoadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var heroes = [Hero]()
    weak var cellDelegate: HeroCellProtocol?
    private var _selectedIndexPath: IndexPath?
    var selectedIndexPath: IndexPath? {
        if let indexPath = tableView.indexPathForSelectedRow {
            return indexPath
        } else {
            return _selectedIndexPath
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HeroCell", bundle: nil), forCellReuseIdentifier: "HeroCell")
        paginationLoadingIndicator.hidesWhenStopped = true
        tableView.tableFooterView = paginationLoadingIndicator

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _selectedIndexPath = tableView.indexPathForSelectedRow
    }
    
    func appendToList(_ items: [Hero]) {
        let indexPaths = (heroes.count..<(heroes.count + items.count)).map { item in
            return IndexPath(item: item, section: 0)
        }
        
        self.heroes.append(contentsOf: items)
        self.tableView.insertRows(at: indexPaths, with: .none)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! HeroCell
        cell.configure(hero: heroes[indexPath.row])
        cell.delegate = cellDelegate
        return cell
    }
}
