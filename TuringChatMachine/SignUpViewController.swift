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
class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var panle: SpringView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewWillAppear(animated: Bool) {
        signUpPanleShowAnimation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTexFields()
        insertBlurView(panle, style: UIBlurEffectStyle.Light)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    func setUpTexFields(){
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.addTextFieldLeftView("username", withLeftPandding: 10, andRightPandding: 10)
        passwordField.addTextFieldLeftView("userpassword", withLeftPandding:13.5, andRightPandding: 13.5)
        emailField.addTextFieldLeftView("email", withLeftPandding: 10.5, andRightPandding: 10.5)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if duration > 0{
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: { () -> Void in
                self.panle.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/3)
                
                }, completion: nil)
        }
        
    }
    func keyboardWillHide(notification: NSNotification) {
        
        let userInfo = notification.userInfo as NSDictionary!
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if duration > 0{
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: { () -> Void in
                self.panle.transform = CGAffineTransformIdentity
                
                }, completion: nil)
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailField{ //如果用户名输入框点击换行就跳到密码输入框
            print("email!")
            textField.resignFirstResponder()
            usernameField.becomeFirstResponder()
        }else if textField == usernameField{//如果是密码输入框回车同时用户名完成输入，就进行登陆操作
            print("username!")
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            
        }else if textField == passwordField && emailField.hasText() && usernameField.hasText() && passwordField.hasText(){
            print("password")
            textField.resignFirstResponder()
            signUpAction(self)
            
        }
     return true
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

