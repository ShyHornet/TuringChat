//
//  WelcomeViewController.swift
//  TuringChatMachine
//
//
//
//                                          ___                        ___
//     ___                                 /  /\          ___         /  /\
//    /  /\                               /  /::\        /__/\       /  /:/_
//   /  /:/               ___     ___    /  /:/\:\       \  \:\     /  /:/ /\
//  /__/::\              /__/\   /  /\  /  /:/  \:\       \  \:\   /  /:/ /:/_
//  \__\/\:\__           \  \:\ /  /:/ /__/:/ \__\:\  ___  \__\:\ /__/:/ /:/ /\
//     \  \:\/\           \  \:\  /:/  \  \:\ /  /:/ /__/\ |  |:| \  \:\/:/ /:/
//      \__\::/            \  \:\/:/    \  \:\  /:/  \  \:\|  |:|  \  \::/ /:/
//      /__/:/              \  \::/      \  \:\/:/    \  \:\__|:|   \  \:\/:/
//      \__\/                \__\/        \  \::/      \__\::::/     \  \::/
//                                         \__\/           ~~~~       \__\/
//       ___          _____          ___                       ___           ___           ___
//      /  /\        /  /::\        /  /\        ___          /  /\         /__/\         /  /\
//     /  /::\      /  /:/\:\      /  /::\      /  /\        /  /::\        \  \:\       /  /::\
//    /  /:/\:\    /  /:/  \:\    /  /:/\:\    /  /:/       /  /:/\:\        \  \:\     /  /:/\:\
//   /  /:/~/::\  /__/:/ \__\:|  /  /:/~/:/   /__/::\      /  /:/~/::\   _____\__\:\   /  /:/~/::\
//  /__/:/ /:/\:\ \  \:\ /  /:/ /__/:/ /:/___ \__\/\:\__  /__/:/ /:/\:\ /__/::::::::\ /__/:/ /:/\:\
//  \  \:\/:/__\/  \  \:\  /:/  \  \:\/:::::/    \  \:\/\ \  \:\/:/__\/ \  \:\~~\~~\/ \  \:\/:/__\/
//   \  \::/        \  \:\/:/    \  \::/~~~~      \__\::/  \  \::/       \  \:\  ~~~   \  \::/
//    \  \:\         \  \::/      \  \:\          /__/:/    \  \:\        \  \:\        \  \:\
//     \  \:\         \__\/        \  \:\         \__\/      \  \:\        \  \:\        \  \:\
//      \__\/                       \__\/                     \__\/         \__\/         \__\/
//
//
//
//
//
//  Created by Huangjunwei on 15/9/11.
//  Copyright (c) 2015年 codeGlider. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Alamofire
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}
class WelcomeViewController: UIViewController,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    var loginVC:LogInViewController!
    var signUpVC:SignUpViewController!
    var logo:UIImageView!
    var welcomeLabel:UILabel!
    var isSignUp = false

    
     override func viewWillAppear(animated: Bool) {

        view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true
        
 if (PFUser.currentUser() != nil){
        self.welcomeLabel.text = "欢迎 \(PFUser.currentUser()!.username!)!"
    delay(seconds: 2.0, completion: { () -> () in
        let  chatVC = ChatViewController()
        chatVC.title = "灵灵"
           let naviVC  =  UINavigationController(rootViewController: chatVC)
        self.presentViewController(naviVC, animated: true, completion: nil)
    })
 }else{
    self.welcomeLabel.text = "未登录"
    delay(seconds: 2.0) { () -> () in
        self.loginVC = LogInViewController()
        self.loginVC.delegate = self
        self.signUpVC = SignUpViewController()
        self.signUpVC.delegate = self
        self.loginVC.signUpController = self.signUpVC
        self.presentViewController(self.loginVC, animated: true, completion: nil)
        }
    
    
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       logo = UIImageView(image: UIImage(named: "logo"))
        logo.center = CGPoint(x: view.center.x, y: view.center.y - 50)
        welcomeLabel = UILabel(frame: CGRect(x: view.center.x - 150/2, y: view.center.y + 20, width: 150, height: 50))
        welcomeLabel.font = UIFont.systemFontOfSize(22)
        welcomeLabel.textColor = UIColor(red:0.11, green:0.55, blue:0.86, alpha:1)
        welcomeLabel.textAlignment = .Center
        view.addSubview(welcomeLabel)
        
        view.addSubview(logo)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:登陆相关代理方法
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if (!username.isEmpty && !password.isEmpty )
        {
        return true
        }
        UIAlertView(title: "缺少信息", message: "请补全缺少的信息", delegate: self, cancelButtonTitle:"确定").show()

        
        return false
    }
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        print("登陆成功")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print(error?.userInfo)
        UIAlertView(title: "用户名或密码错误", message: "请重试", delegate: self, cancelButtonTitle:"确定").show()
    }
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
    }
    //MARK:注册相关代理方法
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {

        var infomationComplete = true
        for key in info.values {
        let field = key as! String
            if (field.isEmpty){
            infomationComplete = false
                break
            }
        }
        
        if (!infomationComplete){
           

            UIAlertView(title: "缺少信息", message: "请补全缺少的信息", delegate: self, cancelButtonTitle:"确定").show()
            
        return false
        }
        return true
    }
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        isSignUp = true
          UIAlertView(title: "注册成功!", message: "请输入用户名和密码登陆", delegate: self, cancelButtonTitle:"确定").show()
       self.dismissViewControllerAnimated(true, completion: nil)

    }
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("注册失败")
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
