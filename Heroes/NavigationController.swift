//
//  NavigationViewController.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, HeroesListTableViewControllerProtocol, UIViewControllerTransitioningDelegate {

    private var animationData: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func userDidSelectedItem(hero: Result, animationView: UIView?) {
        self.animationData = animationView
        let vc = HeroDetailsViewController(hero: hero)
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HeroListToDetailsTransition(animationData:animationData)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HeroDetailsTolistTransition(animationData:animationData)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func navigationController(_: UINavigationController, animationControllerFor: UINavigationController.Operation, from: UIViewController, to: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        return HeroListToDetailsTransition()
//
//    }
    
//    - (id<UIViewControllerAnimatedTransitioning>)
//    navigationController:(UINavigationController *)navigationController
//    animationControllerForOperation:(UINavigationControllerOperation)operation
//    fromViewController:(UIViewController *)fromVC
//    toViewController:(UIViewController *)toVC {
//    
//    if ([fromVC isKindOfClass:DKRideDestinationViewController.class] &&
//    [toVC isKindOfClass:DKRideWaitingForDriverViewController.class]) {
//    
//    return [[DKAnimationToWaitingForDriver alloc] init];
//    }
//    
//    if (([fromVC isKindOfClass:DKRideRequestViewController.class] && [toVC isKindOfClass:DKRideDestinationViewController.class]) ||
//    ([fromVC isKindOfClass:DKRideDestinationViewController.class] && [toVC isKindOfClass:DKRideRequestViewController.class])) {
//    return [[DKAnimationFadeTo alloc] init];
//    }
    

}
