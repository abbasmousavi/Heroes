//
//  HeroListToDetailsTransition.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import Foundation
import UIKit

protocol SourceOfAnimatedTransition {
    func view () -> UIView
}

class HeroListToDetailsTransition: NSObject, UIViewControllerAnimatedTransitioning  {
    
    private var animationSource: SourceOfAnimatedTransition
    init(animationSource: SourceOfAnimatedTransition) {
        self.animationSource = animationSource
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! HeroDetailsViewController
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)
        containerView.sendSubviewToBack(toViewController.view)
        
       let pit = animationSource.view().resizableSnapshotView(from: animationSource.view().bounds, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        
        pit?.frame = fromViewController.view.convert(animationSource.view().frame, from:animationSource.view().superview)
       containerView.addSubview(pit!)
        
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
           
            pit?.frame = toViewController.mainImage.frame
            //fromViewController.view.alpha = 0.0
            
        }) { finished in
            toViewController.view.alpha = 1.0
            pit?.removeFromSuperview()
            
            transitionContext.completeTransition(true)
            //fromViewController.view.alpha = 1.0
        }
    }
    
    
}

class HeroDetailsTolistTransition: NSObject, UIViewControllerAnimatedTransitioning  {
    
    private var animationSource: SourceOfAnimatedTransition
    init(animationSource: SourceOfAnimatedTransition) {
        self.animationSource = animationSource
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! HeroDetailsViewController
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        toViewController.view.frame = finalFrameForVC
        //toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)
        containerView.sendSubviewToBack(toViewController.view)
        
        
        let pit = fromViewController.mainImage?.resizableSnapshotView(from: fromViewController.mainImage.bounds, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        
        containerView.addSubview(pit!)
        pit?.frame = fromViewController.mainImage.frame
        

        let frame = toViewController.view.convert(animationSource.view().frame, from:animationSource.view().superview)

        fromViewController.view.removeFromSuperview()


        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {

            pit?.frame = frame
            //fromViewController.view.alpha = 0.0

        }) { finished in
            //toViewController.view.alpha = 1.0
            pit?.removeFromSuperview()

            transitionContext.completeTransition(true)
            //fromViewController.view.alpha = 1.0
        }
    }
    
    
}



