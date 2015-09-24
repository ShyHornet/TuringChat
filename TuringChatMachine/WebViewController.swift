//
//  WebViewController.swift
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
//  Created by Huangjunwei on 15/9/9.
//  Copyright (c) 2015年 codeGlider. All rights reserved.
//

import UIKit
import SnapKit
class WebViewController: UIViewController{
    var webView:UIWebView!
    var preButton:UIButton!
    var nextButton:UIButton!
    var closeButton:UIButton!
     let url:String!
    init(url:String){
        self.url = url
        self.webView = UIWebView(frame: CGRectZero)
        super.init(nibName: nil, bundle: nil)
        
        
    
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        self.navigationController?.navigationBarHidden = true
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        preButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 22.25, height: 25)))
        preButton.setBackgroundImage(UIImage(named: "pre"), forState: UIControlState.Normal)
         view.addSubview(preButton)
        preButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(15)
            make.top.equalTo(view.snp_top).offset(25)
        }
        preButton.addTarget(self, action: "goPrePage:", forControlEvents: UIControlEvents.TouchUpInside)
    
        nextButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 22.25, height: 25)))
        nextButton.setBackgroundImage(UIImage(named: "next"), forState: UIControlState.Normal)
        view.addSubview(nextButton)
        nextButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(preButton.snp_left).offset(35)
            make.top.equalTo(view.snp_top).offset(25)
        }
        nextButton.addTarget(self, action: "goNextPage:", forControlEvents: UIControlEvents.TouchUpInside)
        
       closeButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 22, height: 21.5)))
        closeButton.setBackgroundImage(UIImage(named: "close"), forState: UIControlState.Normal)
        view.addSubview(closeButton)
        closeButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view.snp_right).offset(-20.5)
            make.top.equalTo(view.snp_top).offset(25)
        }
        closeButton.addTarget(self, action: "closeWebView:", forControlEvents: UIControlEvents.TouchUpInside)
        
       view.addSubview(webView)
        webView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp_top).offset(60)
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.bottom.equalTo(view.snp_bottom)
        }
        
        let request = NSURLRequest(URL: NSURL(string: self.url)!)
        webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }
    func closeWebView(sender:UIButton){
    
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    func goPrePage(sender:UIButton){
    self.webView.goBack()
    }
    func goNextPage(sender:UIButton){
    self.webView.goForward()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
