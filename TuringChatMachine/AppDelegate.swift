//
//  AppDelegate.swift
//  TuringChatMachine
//
//  Created by Huangjunwei on 15/9/2.
//  Copyright (c) 2015年 codeGlider. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Alamofire
let api_key = "65ea3d47b58d8866bed4182af741a60b"
let api_url = "http://www.tuling123.com/openapi/api"
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
 
        Parse.setApplicationId("CYdFL9mvG8jHqc4ZA5PJsWMInBbMMun0XCoqnHgf", clientKey: "6tGOC1uIKeYp5glvJE6MXZOWG9pmLtMuIUdh2Yzo")

        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions) { (success, Error) -> Void in
            guard success else{
               print("Analytics failed! \(Error?.userInfo)")
                return
            }
            print("Analytics successed!")
            
        }
         let HomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
     

        
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(red:0.27, green:0.75, blue:0.91, alpha:1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)
        
        window!.rootViewController = UINavigationController(rootViewController:HomeVC)
        window!.makeKeyAndVisible()
        return true
    }
    
    func application(application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print(userActivityType)
        
        return false
    }
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
         print(userActivity.userInfo)
        print(userActivity.webpageURL)
        
        if let win = window{
            let rootController = win.rootViewController as! UINavigationController
            let viewController = rootController.topViewController as! ChatViewController
           
            
           viewController.restoreUserActivityState(userActivity)
        
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
extension AppDelegate:UINavigationControllerDelegate{


}

