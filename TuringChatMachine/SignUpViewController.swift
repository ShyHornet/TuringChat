//
//  SignUpViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/30/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse
import Spring
import SVProgressHUD
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var panle: SpringView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewWillAppear(animated: Bool) {
        signUpPanleShowAnimation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func signUpPanleShowAnimation(){
        panle.animation = "fadeInUp"
        panle.autostart = false
        panle.curve = "easeOut"
        panle.duration = 1.0
        panle.damping = 0.6
        panle.velocity = 0.0
        panle.force = 1.0
        panle.animate()
    }
    @IBAction func signUpAction(sender: AnyObject) {
        let username = self.usernameField.text!
        let password = self.passwordField.text!
        let email = self.emailField.text!
        let finalEmail = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if username.getLength() < 5 {
            SVProgressHUD.showErrorWithStatus("用户名长度必须大于5个字符")
            
            return
        }else if
        password.getLength() < 8{
            SVProgressHUD.showErrorWithStatus("密码长度必须大于8个字符")
            return
        }
        else if  email.getLength() < 8 {
            SVProgressHUD.showErrorWithStatus("请输入正确的电子邮箱地址")
            return
        }
      SVProgressHUD.showWithStatus("注册中")
        
        let newUser = PFUser()
        
        newUser.username = username
        newUser.password = password
        newUser.email = finalEmail

        // Sign up the user asynchronously
        newUser.signUpInBackgroundWithBlock({ (succees, error) -> Void in
            
            // Stop the spinner
        
           SVProgressHUD.dismiss()
            if error == nil {
                print(error)
               SVProgressHUD.showSuccessWithStatus("注册成功!")
                  dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
                
            }else{
            
                SVProgressHUD.showErrorWithStatus("注册失败")
            }
         
            
        })
    }

}

