//
//  NavigationViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, HeroesListViewControllerProtocol, UIViewControllerTransitioningDelegate {

    private var animationData: UIView?
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
    
    func userDidSelectedItem(hero: Hero, animationView: UIView?) {
        self.animationData = animationView
        let vc = HeroDetailsViewController(service: service, hero: hero)
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HeroListToDetailsTransition(animationData:animationData)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HeroDetailsTolistTransition(animationData:animationData)
    }
}
