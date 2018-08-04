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

class HeroesListViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var stateIndicator: StateIndicator!
    private var isDataLoading = false
    private var offset = 0
    private var query: String?
    private let service: Services
    private var heroes = [Hero]()
    weak var delegate: HeroesListViewControllerProtocol?
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBar: UISearchBar { return searchController.searchBar }
    private let paginationLoadingIndicator = UIActivityIndicatorView(style: .gray)
    private var selectedIndexPath: IndexPath? = nil

    init(service: Services) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(UINib(nibName: "HeroCell", bundle: nil), forCellReuseIdentifier: "HeroCell")
        self.title = "Characters"
        self.configureSearchController()
        paginationLoadingIndicator.hidesWhenStopped = true
        tableView.tableFooterView = paginationLoadingIndicator
        stateIndicator.startLoading()
        loadHeroes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        offset = 0
        query = searchBar.text
        heroes = []
        tableView.reloadData()
        stateIndicator.startLoading()
        loadHeroes(query: searchBar.text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if query != nil {

            offset = 0
            query = nil
            heroes = []
            tableView.reloadData()
            stateIndicator.startLoading()
            loadHeroes()
        }
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

            let indexPaths = (self.heroes.count..<(self.heroes.count + result.value!.data.results.count)).map { item in
                return IndexPath(item: item, section: 0)
            }

            self.heroes.append(contentsOf: result.value!.data.results)

            if (self.heroes.count > 0) {
                self.stateIndicator.stopLoading()
            } else {
                self.stateIndicator.stopLoading(message: "No items available")
            }
            self.tableView.insertRows(at: indexPaths, with: .none)
            self.offset += 1

            self.paginationLoadingIndicator.stopAnimating()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isDataLoading = true
                paginationLoadingIndicator.startAnimating()
                loadHeroes(query: query)
            }
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
        self.definesPresentationContext = true;
    }
}

extension HeroesListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! HeroCell
        cell.configure(hero: heroes[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            delegate?.userDidSelectedItem(hero: heroes[indexPath.row])
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

extension HeroesListViewController: SourceOrDestinationOfAnimatedTransition {
    func view() -> UIView {

        if let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: indexPath) as? HeroCell {
            return cell.mainImageView
        } else {
            return self.view
        }
    }
}
