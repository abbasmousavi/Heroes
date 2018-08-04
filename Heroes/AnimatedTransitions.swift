//
//  HeroListToDetailsTransition.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/2/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import Foundation
import UIKit

protocol DestinationOfAnimatedTransition {
    func destinationView () -> UIView
}

protocol SourceOfAnimatedTransition {
    func sourceView () -> UIView
}

class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private var source: SourceOfAnimatedTransition
    private var destination: DestinationOfAnimatedTransition
    init(source: SourceOfAnimatedTransition, destination: DestinationOfAnimatedTransition) {
        self.source = source
        self.destination = destination
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)

        let sourceSnapshot = source.sourceView().resizableSnapshotView(from: source.sourceView().bounds, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)

        sourceSnapshot?.frame = fromViewController.view.convert(source.sourceView().frame, from: source.sourceView().superview)
        containerView.addSubview(sourceSnapshot!)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {

                sourceSnapshot?.frame = self.destination.destinationView().frame

            }) { finished in
            toViewController.view.alpha = 1.0
            sourceSnapshot?.removeFromSuperview()
            transitionContext.completeTransition(true)

        }
    }
}

class ReverseAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var source: SourceOfAnimatedTransition
    private var destination: DestinationOfAnimatedTransition
    init(source: SourceOfAnimatedTransition, destination: DestinationOfAnimatedTransition) {
        self.source = source
        self.destination = destination
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        toViewController.view.frame = finalFrameForVC
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        let sourceSnapshot = source.sourceView().resizableSnapshotView(from: source.sourceView().bounds, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
        
        sourceSnapshot?.frame = fromViewController.view.convert(source.sourceView().frame, from: source.sourceView().superview)
        containerView.addSubview(sourceSnapshot!)
        fromViewController.view.removeFromSuperview()
        let destinationframe = toViewController.view.convert(destination.destinationView().frame, from: destination.destinationView().superview)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            sourceSnapshot?.frame = destinationframe
            
        }) { finished in

            sourceSnapshot?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
