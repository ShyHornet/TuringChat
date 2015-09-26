//
//  CircleTransitionAnimator.swift
//  CircleTransition
//
//  Created by Rounak Jain on 23/10/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

import UIKit

class FadeInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration:Double = 0.5
  weak var transitionContext: UIViewControllerContextTransitioning?

  var operation:UINavigationControllerOperation = .Push
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return animationDuration;
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    self.transitionContext = transitionContext
    if operation == .Push{
    let containerView = transitionContext.containerView()
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

    
    toViewController!.view.alpha = 0.0
    //toViewController!.navigationController?.navigationBarHidden = false
    containerView!.addSubview(toViewController!.view)
    
     UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
       
        fromViewController!.view.alpha = 0.0
        fromViewController!.view.transform = CGAffineTransformMakeScale(2.0,2.0)
        toViewController!.view.alpha = 1.0
        if let  toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? ChatViewController{
          toViewController.navigationController?.setNavigationBarHidden(false, animated:false)
            toViewController.navigationController?.navigationBar.tintColor = UIColor(red:0.35, green:0.78, blue:0.92, alpha:1)
        
        }
        
        }, completion:{ (finish) -> Void in
            
            transitionContext.completeTransition(true)
            fromViewController!.view.alpha = 1.0
            fromViewController!.view.transform = CGAffineTransformIdentity
            
     })
    }else{
        let containerView = transitionContext.containerView()
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        
        toViewController!.view.alpha = 0.0

        containerView!.addSubview(toViewController!.view)
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            fromViewController!.view.alpha = 0.0
            fromViewController!.view.transform = CGAffineTransformMakeScale(0,0)
            toViewController!.view.alpha = 1.0
            toViewController!.navigationController?.setNavigationBarHidden(true, animated:false)
            }, completion:{ (finish) -> Void in
                
                transitionContext.completeTransition(true)
                fromViewController!.view.alpha = 1.0
                //fromViewController!.view.transform = CGAffineTransformIdentity
                
        })

    
    }
  }
  
  override func animationDidStop(anim: CAAnimation!,finished flag: Bool) {
    
    if let context = transitionContext {
    self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
      
    }
    transitionContext = nil
  }
  
}
