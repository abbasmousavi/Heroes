//
//  HeroesListTableViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/1/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

protocol HeroesListViewControllerProtocol: class {
    func userDidSelectItem(_ item: Hero)
}

class HeroesListViewController: UIViewController {
    private var listController = HeroListController(style: .plain)
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar { return searchController.searchBar }
    @IBOutlet private var stateIndicator: StateIndicator!
    private let service: Services
    private var isDataLoading = false
    weak var delegate: HeroesListViewControllerProtocol?
    private var offset = 0
    private var query: String?

    init(service: Services) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        addChild(listController, in: view)
        stateIndicator.delegate = self
        view.sendSubview(toBack: listController.view)
        listController.delegate = self
        listController.cellDelegate = self
        title = "Characters"
        searchBar.delegate = self
        stateIndicator.startLoading()
        loadHeroes()
    }

    func loadHeroes() {
        isDataLoading = true
        service.loadHeroesList(query: query, offset: offset * 20) { (result: Result<Hero>) in

            self.isDataLoading = false
            self.listController.stopLoadingAnimation()
            guard result.isSuccess else {
                if (self.offset == 0) {
                    self.stateIndicator.stopLoading(error: result.error!)
                }
                return
            }

            self.listController.appendToList((result.value?.data.results)!)

            if self.listController.heroes.count > 0 {
                self.stateIndicator.stopLoading()
            } else {
                self.stateIndicator.stopLoading(message: "No items available")
            }

            self.offset += 1
        }
    }

    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search by character name"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        definesPresentationContext = true
    }
}

extension HeroesListViewController: HeroListControllerProtocol {
    func userDidRequestLoadingMoreItems() {
        if !isDataLoading {
            loadHeroes()
        }
    }

    func userDidSelectItem(_ item: Hero) {
        delegate?.userDidSelectItem(item)
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
        offset = 0
        query = searchBar.text
        listController.emptyList()
        stateIndicator.startLoading()
        query = searchBar.text
        loadHeroes()
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        if query != nil {
            offset = 0
            query = nil
            listController.emptyList()
            stateIndicator.startLoading()
            loadHeroes()
        }
    }
}

extension HeroesListViewController: StateIndicatorProtocol {
    func userDidRequestRetry() {
        stateIndicator.startLoading()
        loadHeroes()
    }
}

extension HeroesListViewController: SourceOfAnimatedTransition {
    func sourceView() -> UIView {
        if let indexPath = listController.selectedIndexPath,
            let cell = listController.tableView.cellForRow(at: indexPath) as? HeroCell {
            return cell.mainImageView
        } else {
            return view
        }
    }
}

extension HeroesListViewController: DestinationOfAnimatedTransition {
    func destinationView() -> UIView {
        if let indexPath = listController.selectedIndexPath,
            let cell = listController.tableView.cellForRow(at: indexPath) as? HeroCell {
            return cell.mainImageView
        } else {
            return view
        }
    }
}
