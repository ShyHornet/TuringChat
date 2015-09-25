//
//  CircleTransitionAnimator.swift
//  CircleTransition
//
//  Created by Rounak Jain on 23/10/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

import UIKit

class FadeInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration:Double = 1.0
  weak var transitionContext: UIViewControllerContextTransitioning?
    
  var operation:UINavigationControllerOperation = .Push
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return animationDuration;
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    
    let containerView = transitionContext.containerView()
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! HomeViewController
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ChatViewController
    toViewController.view.alpha = 0.0
    toViewController.navigationController?.navigationBarHidden = true
    print("Animating...")
    containerView!.addSubview(toViewController.view)
     UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
       
        fromViewController.view.alpha = 0.2
        fromViewController.panle.transform = CGAffineTransformMakeScale(1.5, 1.5)
        toViewController.view.alpha = 1.0
        toViewController.navigationController?.setNavigationBarHidden(false, animated: true)
        }, completion:{ (finish) -> Void in
            transitionContext.completeTransition(true)
            
     })

  }
  
  override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
    self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
  
  }
  
}
