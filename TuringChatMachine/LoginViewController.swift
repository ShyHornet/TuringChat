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
import SVProgressHUD
class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var loginPanle: SpringView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func unwindToLogInScreen(segue:UIStoryboardSegue) {
    }
    @IBOutlet weak var backGround: UIImageView!
    override func viewWillAppear(animated: Bool) {
 
    
        loginPanleShowAnimation()
        self.navigationController?.navigationBarHidden = true
        if PFUser.currentUser() != nil{
            username.text = PFUser.currentUser()?.username
            password.text = PFUser.currentUser()?.password
            delay(seconds: 1.0, completion: { () -> () in
                 self.navigationController?.popViewControllerAnimated(true)
            })
       
        }
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
        if textField == username{ //如果用户名输入框点击换行就跳到密码输入框
            textField.resignFirstResponder()
            password.becomeFirstResponder()
        }else if textField == password && username.hasText() && password.hasText(){//如果是密码输入框回车同时用户名完成输入，就进行登陆操作
            
        textField.resignFirstResponder()
        login()
        }
        return true
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        setUpTextField()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
         notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    func setUpTextField(){
        password.delegate = self
        username.delegate = self
        username.addTextFieldLeftView("username", withLeftPandding: 10, andRightPandding: 10)
        password.addTextFieldLeftView("userpassword", withLeftPandding:13.5, andRightPandding: 13.5)
        
        username.returnKeyType = .Next
        password.secureTextEntry = true
        password.returnKeyType = .Done
    
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
                     self.loginPanle.transform = CGAffineTransformMakeTranslation(0,-frameNew.height/3)
                
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
            SVProgressHUD.showErrorWithStatus("用户名长度必须大于4个字符")
            return
        }
        guard password?.getLength() >= 8 else{
           SVProgressHUD.showErrorWithStatus("密码长度必须大于8个字符")
            return
        }
        

   
        PFUser.logInWithUsernameInBackground(username!, password: password!) { (user,error) -> Void in
            
            guard user != nil else{
            print(error?.userInfo)
               
                
              SVProgressHUD.showErrorWithStatus("登陆失败╮(╯﹏╰）╭")
                
                return
            }
            SVProgressHUD.dismiss()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
                self.navigationController?.popViewControllerAnimated(true)
            })
            
            
        }
    }


}
