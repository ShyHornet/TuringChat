//
//  SignUpViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/30/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        let username = self.usernameField.text!
        let password = self.passwordField.text!
        let email = self.emailField.text!
        let finalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        guard username.getLength() >= 5 else{
            let alert = UIAlertView(title: "错误", message: "用户名必须大于5个字符！", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        guard password.getLength() >= 8 else{
            let alert = UIAlertView(title: "错误", message: "密码必须大于5个字符！", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        guard email.getLength() >= 8 else{
            let alert = UIAlertView(title: "错误", message: "请输入正确的电子邮箱地址！", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            return
        }
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        let newUser = PFUser()
        
        newUser.username = username
        newUser.password = password
        newUser.email = finalEmail
        
        // Sign up the user asynchronously
        newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            
            // Stop the spinner
            spinner.stopAnimating()
            guard ((error) != nil) else {
                let alert = UIAlertView(title: "错误", message: "\(error)", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                return
                
            }
            let alert = UIAlertView(title: "成功", message: "已注册！ ", delegate: self, cancelButtonTitle: "确定")
            alert.show()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
            
        })
    }
    
}

