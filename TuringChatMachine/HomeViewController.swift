//
//  HomeViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/31/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse
import Spring

func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}
class HomeViewController: UIViewController {
    
    @IBOutlet weak var AvatarImage: SpringImageView!
    @IBOutlet weak var panle: SpringView!
    @IBOutlet weak var logInStatus: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    let transition = FadeInTransitionAnimator()
    override func viewWillAppear(animated: Bool) {
        homePanleShowAnimation()
        avatarImageShowAnimation()
       
        if (PFUser.currentUser() == nil) {
            logInStatus.text = "未登录"
            usernameLabel.text = "无用户"
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                delay(seconds: 1.5, completion: { () -> () in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                    //viewController.view.backgroundColor = UIColor.whiteColor()
                    
                    self.navigationController?.view.backgroundColor = UIColor.whiteColor()
                    self.navigationController?.pushViewController(viewController, animated: true)
                    //self.presentViewController(viewController, animated: true, completion: nil)
                    
                })
                
            })
        }else{
            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.width/2 - 25,100, 50, 50)) as UIActivityIndicatorView
            spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            
            self.view.addSubview(spinner)
            spinner.startAnimating()
            logInStatus.text = "登陆中"
            if let name = PFUser.currentUser()?.username{
                self.usernameLabel.text = "@" + name
            
            }
            
            delay(seconds: 1.5, completion: { () -> () in
                let ChatVC = ChatViewController()
                        self.logInStatus.text = "登陆成功"
                spinner.stopAnimating()
                self.navigationController?.pushViewController(ChatVC, animated: true)
                
                //self.presentViewController(naviVC, animated:true, completion: nil)
            })
            
        }
    }
    func homePanleShowAnimation(){
        if (PFUser.currentUser() == nil) {
            logInStatus.enabled  =  false
            usernameLabel.text = "无用户"
        }
        panle.animation = "fadeInUp"
        panle.autostart = false
        panle.curve = "easeOut"
        panle.duration = 1.0
        panle.damping = 0.6
        panle.velocity = 0.0
        panle.force = 1.0
        panle.animate()
    }
    func avatarImageShowAnimation(){
        
        AvatarImage.animation = "zoomIn"
        AvatarImage.autostart = false
        AvatarImage.curve = "easeOut"
        AvatarImage.duration = 1.0
        AvatarImage.velocity = 0.0
        AvatarImage.damping = 0.6
        AvatarImage.force = 1.0
        AvatarImage.animate()
    }

    override func viewDidLoad() {
        self.preferredStatusBarStyle()
      
        
       self.navigationController?.navigationBar.tintColor = UIColor(red:0.35, green:0.78, blue:0.92, alpha:1)
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        navigationController?.delegate = self
          }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension HomeViewController:UINavigationControllerDelegate{
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

            transition.operation = operation
            
            return transition

        
    }
    
}
