//
//  HeroListTableViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/5/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

private let reuseIdentifier = String(describing: HeroCell.self)

protocol HeroListControllerProtocol: class {
    func userDidRequestLoadingMoreItems()
    func userDidSelectItem(_ item: Hero)
}

class HeroListController: UITableViewController {
    private let paginationLoadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var heroes = [Hero]()
    weak var cellDelegate: HeroCellProtocol?
    weak var delegate: HeroListControllerProtocol?
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
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        paginationLoadingIndicator.hidesWhenStopped = true
        tableView.tableFooterView = paginationLoadingIndicator

        // Uncomment the following line to preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 70
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _selectedIndexPath = tableView.indexPathForSelectedRow
    }

    func appendToList(_ items: [Hero]) {
        let indexPaths = (heroes.count ..< (heroes.count + items.count)).map { item in
            return IndexPath(item: item, section: 0)
        }

        heroes.append(contentsOf: items)
        tableView.insertRows(at: indexPaths, with: .none)
    }

    func emptyList() {
        heroes = []
        tableView.reloadData()
    }

    func stopLoadingAnimation() {
        paginationLoadingIndicator.stopAnimating()
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = tableView.contentSize.height
        var scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        if tableView.contentSize.height < tableView.bounds.size.height {
            scrollOffsetThreshold = tableView.bounds.size.height
        }

        if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
            paginationLoadingIndicator.startAnimating()
            delegate?.userDidRequestLoadingMoreItems()
        }
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.userDidSelectItem(heroes[indexPath.row])
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return heroes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? HeroCell
        cell?.configure(hero: heroes[indexPath.row], delegate: cellDelegate)
        return cell!
    }
}
