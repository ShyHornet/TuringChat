//
//  LoginViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/28/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        password.secureTextEntry = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(sender: UIButton) {
        let username = self.username.text
        let password = self.password.text
        
        guard username?.getLength() >= 4 else{
            let alert = UIAlertView(title: "登陆错误", message: "用户名长度必须大于4个字符", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        guard password?.getLength() >= 8 else{
            let alert = UIAlertView(title: "登陆错误", message: "密码长度必须大于8个字符", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(self.view.frame.width/2 - 25,100, 50, 50)) as UIActivityIndicatorView
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        
        self.view.addSubview(spinner)
        spinner.startAnimating()
        PFUser.logInWithUsernameInBackground(username!, password: password!) { (user,error) -> Void in
            spinner.stopAnimating()
            guard user != nil else{
                let alert = UIAlertView(title: "错误 ", message: "\(error)", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                
                return
            }

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            
            
        }
        
        
        
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
