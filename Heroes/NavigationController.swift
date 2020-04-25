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

    init(service: Services) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let initialViewController = HeroesListViewController(service: service)
        initialViewController.delegate = self
        viewControllers = [initialViewController]
    }

    func animationController(forPresented presented: UIViewController, presenting _: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let source = topViewController as? SourceOfAnimatedTransition,
            let destination = presented as? DestinationOfAnimatedTransition {
            return AnimatedTransition(source: source, destination: destination)
        }
        return nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let source = dismissed as? SourceOfAnimatedTransition,
            let destination = topViewController as? DestinationOfAnimatedTransition {
            return ReverseAnimatedTransition(source: source, destination: destination)
        }
        return nil
    }
}

extension NavigationController: HeroesListViewControllerProtocol {
    func userDidSelectItem(_ item: Hero) {
        let vc = HeroDetailsViewController(service: service, hero: item)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
