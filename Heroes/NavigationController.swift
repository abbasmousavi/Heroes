//
//  NavigationViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {

    private let service: Services

    init (service: Services) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let initialViewController = HeroesListViewController(service: service)
        initialViewController.delegate = self
        self.viewControllers = [initialViewController]
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if let source = topViewController as? SourceOrDestinationOfAnimatedTransition,
            let destination = presented as? SourceOrDestinationOfAnimatedTransition {
            return HeroListToDetailsTransition(source: source, destination: destination)
        }
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if let source = dismissed as? SourceOrDestinationOfAnimatedTransition,
            let destination = topViewController as? SourceOrDestinationOfAnimatedTransition {
            return HeroDetailsTolistTransition(source: source, destination: destination)
        }
        return nil
    }
}
extension NavigationController: HeroesListViewControllerProtocol {

    func userDidSelectedItem(hero: Hero) {
        let vc = HeroDetailsViewController(service: service, hero: hero)
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}
