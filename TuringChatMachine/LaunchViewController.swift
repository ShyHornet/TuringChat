//
//  LaunchViewController.swift
//  TuringChatMachine
//
//  Created by codeGlider on 15/9/29.
//  Copyright © 2015年 codeGlider. All rights reserved.
//

import UIKit
import Spring
class LaunchViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    override func viewWillAppear(animated: Bool) {
        let logoGoUpAnimation = CABasicAnimation(keyPath: "position.y")
        logoGoUpAnimation.beginTime = CACurrentMediaTime()
        logoGoUpAnimation.duration = 2.0
        logoGoUpAnimation.fillMode = kCAFillModeForwards
        logoGoUpAnimation.removedOnCompletion = false
        logoGoUpAnimation.timingFunction = getTimingFunction(AnimationCurve.EaseOutCirc)
        logoGoUpAnimation.fromValue = 367 - 33
        logoGoUpAnimation.repeatCount = 1
        
        logoGoUpAnimation.toValue = 367 - 33 - 230
        logo.layer.addAnimation(logoGoUpAnimation, forKey: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
enum AnimationCurve: String {
    case EaseIn = "easeIn"
    case EaseOut = "easeOut"
    case EaseInOut = "easeInOut"
    case Linear = "linear"
    case Spring = "spring"
    case EaseInSine = "easeInSine"
    case EaseOutSine = "easeOutSine"
    case EaseInOutSine = "easeInOutSine"
    case EaseInQuad = "easeInQuad"
    case EaseOutQuad = "easeOutQuad"
    case EaseInOutQuad = "easeInOutQuad"
    case EaseInCubic = "easeInCubic"
    case EaseOutCubic = "easeOutCubic"
    case EaseInOutCubic = "easeInOutCubic"
    case EaseInQuart = "easeInQuart"
    case EaseOutQuart = "easeOutQuart"
    case EaseInOutQuart = "easeInOutQuart"
    case EaseInQuint = "easeInQuint"
    case EaseOutQuint = "easeOutQuint"
    case EaseInOutQuint = "easeInOutQuint"
    case EaseInExpo = "easeInExpo"
    case EaseOutExpo = "easeOutExpo"
    case EaseInOutExpo = "easeInOutExpo"
    case EaseInCirc = "easeInCirc"
    case EaseOutCirc = "easeOutCirc"
    case EaseInOutCirc = "easeInOutCirc"
    case EaseInBack = "easeInBack"
    case EaseOutBack = "easeOutBack"
    case EaseInOutBack = "easeInOutBack"
}
func getTimingFunction(curve: AnimationCurve) -> CAMediaTimingFunction {
    
    switch curve {
    case .EaseIn: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    case .EaseOut: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    case .EaseInOut: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    case .Linear: return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    case .Spring: return CAMediaTimingFunction(controlPoints: 0.5, 1.1, 1, 1)
    case .EaseInSine: return CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
    case .EaseOutSine: return CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
    case .EaseInOutSine: return CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
    case .EaseInQuad: return CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
    case .EaseOutQuad: return CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
    case .EaseInOutQuad: return CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
    case .EaseInCubic: return CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
    case .EaseOutCubic: return CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
    case .EaseInOutCubic: return CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
    case .EaseInQuart: return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
    case .EaseOutQuart: return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
    case .EaseInOutQuart: return CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
    case .EaseInQuint: return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
    case .EaseOutQuint: return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
    case .EaseInOutQuint: return CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
    case .EaseInExpo: return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
    case .EaseOutExpo: return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
    case .EaseInOutExpo: return CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
    case .EaseInCirc: return CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
    case .EaseOutCirc: return CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
    case .EaseInOutCirc: return CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
    case .EaseInBack: return CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
    case .EaseOutBack: return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
    case .EaseInOutBack: return CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
    }
    
    return CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
}

