//
//  HeroesListTableViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

protocol HeroesListViewControllerProtocol: class {
    func userDidSelectedItem(hero: Hero) -> Void;
}

class HeroesListViewController: UIViewController, UITableViewDelegate {

    private var listController = HeroListController(style: .plain)
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar { return searchController.searchBar }
    @IBOutlet private weak var stateIndicator: StateIndicator!
    private let service: Services
    private var isDataLoading = false
    weak var delegate: HeroesListViewControllerProtocol?
    private var offset = 0
    private var query: String?

    init(service: Services) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSearchController()
        addChild(listController, in: view)
        view.sendSubview(toBack: listController.view)
        listController.tableView.delegate = self
        listController.cellDelegate = self
        self.title = "Characters"
        searchBar.delegate = self
        stateIndicator.startLoading()
        loadHeroes()
    }

    func loadHeroes (query: String? = nil) {
        
       isDataLoading = true
        let parameters: [String: String] = query == nil ? [:] : ["nameStartsWith": query!]
        service.request(uri: "https://gateway.marvel.com/v1/public/characters", parameters: parameters, offset: 20 * offset) { (result: Result<Hero>) in

            self.isDataLoading = false
            guard result.isSuccess else {
                self.stateIndicator.stopLoading(error: result.error!)
                return
            }

            self.listController.appendToList((result.value?.data.results)!)

            if (self.listController.heroes.count > 0) {
                self.stateIndicator.stopLoading()
            } else {
                self.stateIndicator.stopLoading(message: "No items available")
            }
            
            self.offset += 1

            //self.paginationLoadingIndicator.stopAnimating()
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (!isDataLoading) {
//            // Calculate the position of one screen length before the bottom of the results
//            let scrollViewContentHeight = tableView.contentSize.height
//            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
//
//            // When the user has scrolled past the threshold, start requesting
//            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
//                isDataLoading = true
//                paginationLoadingIndicator.startAnimating()
//                loadHeroes(query: query)
//            }
//        }
//    }

    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search by character name"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        self.definesPresentationContext = true;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.userDidSelectedItem(hero: listController.heroes[indexPath.row])
    }



}

extension HeroesListViewController: HeroCellProtocol {
    
    func isFavorite(_ hero: Hero) -> Bool {
        return service.store.isInStore(hero)
    }

    func addFavorite(_ hero: Hero) {
        service.store.save(hero)
    }

    func removeFavorite(_ hero: Hero) {
        service.store.remove(hero)
    }
}

extension HeroesListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        offset = 0
//        query = searchBar.text
//        heroes = []
//        tableView.reloadData()
        //        stateIndicator.startLoading()
        //        loadHeroes(query: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        if query != nil {
        //
        //            offset = 0
        //            query = nil
        //            heroes = []
        //            tableView.reloadData()
        //            stateIndicator.startLoading()
        //            loadHeroes()
        //        }
    }
}

extension HeroesListViewController: SourceOfAnimatedTransition {
    func sourceView() -> UIView {

        if let indexPath = listController.selectedIndexPath,
            let cell = listController.tableView.cellForRow(at: indexPath) as? HeroCell {
            return cell.mainImageView
        } else {
            return self.view
        }
    }
}

extension HeroesListViewController: DestinationOfAnimatedTransition {
    func destinationView() -> UIView {

        if let indexPath = listController.selectedIndexPath,
            let cell = listController.tableView.cellForRow(at: indexPath) as? HeroCell {
            return cell.mainImageView
        } else {
            return self.view
        }

    }}
