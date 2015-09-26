//
//  LoginViewController.swift
//  ParseDemo
//
//  Created by Rumiya Murtazina on 7/28/15.
//  Copyright (c) 2015 abearablecode. All rights reserved.
//

import UIKit
import Parse
import Spring
class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var loginPanle: SpringView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
    }
    override func viewWillAppear(animated: Bool) {
        loginPanleShowAnimation()
        self.navigationController?.navigationBarHidden = true
    }
    func loginPanleShowAnimation(){
        loginPanle.animation = "fadeInLeft"
       loginPanle.autostart = false
        loginPanle.curve = "easeOut"
        loginPanle.duration = 1.0
        loginPanle.damping = 0.6
        loginPanle.velocity = 0.0
        loginPanle.force = 1.0
        loginPanle.animate()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == username{ //如果用户名输入框回车就跳到密码输入框
            textField.resignFirstResponder()
            password.becomeFirstResponder()
        }//如果是密码输入框回车就隐藏键盘
        textField.resignFirstResponder()
  
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == password && username.hasText()//如果密码输入框完成编辑，同时用户名完成输入就执行登陆操作
        {
         login()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate = self
        username.delegate = self
        self.navigationController?.navigationBarHidden = true
        password.secureTextEntry = true
        password.returnKeyType = UIReturnKeyType.Done
        let notificationCenter = NSNotificationCenter.defaultCenter()
         notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
         let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if duration > 0{
         let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: { () -> Void in
                     self.loginPanle.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/2)
                
                }, completion: nil)
        }

    }
    func keyboardWillHide(notification: NSNotification) {
        
        let userInfo = notification.userInfo as NSDictionary!

        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if duration > 0{
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0.0, options: options, animations: { () -> Void in
                self.loginPanle.transform = CGAffineTransformIdentity
                
                }, completion: nil)
        }
        
    }


    @IBAction func loginAction(sender: UIButton) {
  
        login()
        
        
    }
    func login(){
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
                self.navigationController?.popViewControllerAnimated(true)
            })
            
            
        }
    }

}
