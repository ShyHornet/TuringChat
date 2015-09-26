//
//  ChatViewController.swift
//  图灵聊天
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
//  Created by Huangjunwei on 15/9/1.
//  Copyright (c) 2015年 codeGlider. All rights reserved.
//

import UIKit
import SafariServices
import Parse
import ParseUI
import Alamofire
import SnapKit
let messageFontSize: CGFloat = 17
let sentDateFontSize:CGFloat = 10
let toolBarMinHeight: CGFloat = 44
let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)


class ChatViewController:UITableViewController,UITextViewDelegate,SFSafariViewControllerDelegate {
    //MARK:属性定义
    
    
    var toolBar: UIToolbar!
    var textView: UITextView!
    var sendButton: UIButton!
    var rotating = false
    var continuedActivity: NSUserActivity?
    var response:String?
    var messageObjects:[PFObject] = []
    //[[Message(incoming: true, text: "你好，请叫我灵灵，我是主人的贴身小助手!", sentDate: NSDate())]]
    override var inputAccessoryView: UIView! {
        get {
            if toolBar == nil {
                
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))
                
                textView = InputTextView(frame: CGRectZero)
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                //            textView.placeholder = "Message"
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton(type: UIButtonType.Custom)
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                sendButton.setTitle("发送", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: "sendAction", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(sendButton)
                
                // Auto Layout allows `sendButton` to change width, e.g., for localization.
                textView.snp_makeConstraints{ (make) -> Void in
                    
                    make.left.equalTo(self.toolBar.snp_left).offset(8)
                    make.top.equalTo(self.toolBar.snp_top).offset(7.5)
                    make.right.equalTo(self.sendButton.snp_left).offset(-2)
                    make.bottom.equalTo(self.toolBar.snp_bottom).offset(-8)
                    
                    
                }
                sendButton.snp_makeConstraints{ (make) -> Void in
                    make.right.equalTo(self.toolBar.snp_right)
                    make.bottom.equalTo(self.toolBar.snp_bottom).offset(-4.5)
                    
                }
                
            }
            return toolBar
        }
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    //MARK:生命周期管理
    func initData(howMany7DaysBefore:Double){

        var index = 0
 
        let query:PFQuery = PFQuery(className:"Messages")
        if let user = PFUser.currentUser(){
            query.whereKey("createdBy", equalTo: user)
            query.limit = 1000
            query.whereKey("sentDate", greaterThanOrEqualTo:NSDate(timeIntervalSinceNow: -howMany7DaysBefore*7*24*60*60))
            query.whereKey("sentDate", lessThanOrEqualTo:NSDate(timeIntervalSinceNow: (howMany7DaysBefore - 1.0)*7*24*60*60))
            //            self.messages = [[Message(incoming: true, text: "你好，请叫我灵灵，我是主人的贴身小助手!", sentDate: NSDate())]]
        }
        
        query.orderByAscending("sentDate")
        //query.cachePolicy = PFCachePolicy.CacheThenNetwork

        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil {
                self.messageObjects = objects as! [PFObject]
                self.tableView.reloadData()
                
            }else{
                print("Error \(error?.userInfo)")
            }
        }
        
        
        
     
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.initData(1)

        //        tableView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        self.tableView.keyboardDismissMode = .Interactive
        self.tableView.estimatedRowHeight = 44
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:toolBarMinHeight, right: 0)
        
        self.tableView.separatorStyle = .None

       
        
       
        self.navigationItem.setLeftBarButtonItem(itemWithImage("exit", highlightImage: "exit_highlight", target: self, action:"exitButtonTapped:"), animated: true)
        self.navigationItem.setRightBarButtonItem(itemWithImage("setting", highlightImage: "setting_highlight", target: self, action:"settingButtonTapped:"), animated: true)
        title = "灵灵"
        
        
        
        
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func exitButtonTapped(sender:UIButton){
        PFUser.logOut()

        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func settingButtonTapped(sender:UIButton){
        
        
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
         self.navigationController?.navigationBarHidden = false
        
    }

    //MARK:textView代理方法
    func textViewDidChange(textView: UITextView) {
        updateTextViewHeight()
        sendButton.enabled = textView.hasText()
    }
    //MARK:tableView代理方法
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            deleteMessage(messageObjects[indexPath.row])
        messageObjects.removeAtIndex(indexPath.row)
            
            tableView.reloadData()
          
        }
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        guard let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? MessageBubbleTableViewCell else{
            return nil
        }
        
        guard selectedCell.url != "" else{
            return nil
        }
        if #available(iOS 9.0, *) {
            let webVC = SFSafariViewController(URL: NSURL(string:selectedCell.url)!, entersReaderIfAvailable: true)
            webVC.delegate = self
            self.presentViewController(webVC, animated: true, completion: nil)
        } else {
            let webVC = WebViewController(url: selectedCell.url)
            self.presentViewController(webVC, animated: true, completion: nil)
            
        }
        
        return nil
    }
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var currentCellDate:NSDate!
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = NSStringFromClass(MessageBubbleTableViewCell)
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MessageBubbleTableViewCell!
        if cell == nil {
            
            cell = MessageBubbleTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            
        }
        let object =  messageObjects[indexPath.row]
        let message = Message(incoming:object["incoming"] as! Bool, text: object["text"] as! String, sentDate: object["sentDate"] as! NSDate)
        if indexPath.row == 0{
        currentCellDate = message.sentDate
            
        }
        let timeInterval = currentCellDate.timeIntervalSinceDate(message.sentDate)
        var showSentDate = false
        
        if abs(timeInterval) > 120{
        showSentDate = true
        }
        cell.configureWithMessage(message,showSentDate:showSentDate)
        currentCellDate = message.sentDate
        return cell
        
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if messageObjects.count > 0{
            return messageObjects.count
        }else{
            return 0
        }
    }
    
    
    //MARK:发送操作及帮助方法
    func saveMessage(message:Message){
        let saveObject = PFObject(className: "Messages")
        saveObject["incoming"] = message.incoming
        saveObject["text"] = message.text
        saveObject["sentDate"] = message.sentDate
        saveObject["url"] = message.url
        
        let user = PFUser.currentUser()
        saveObject["createdBy"] = user
        messageObjects.append(saveObject)
        saveObject.saveEventually { (success, error) -> Void in
            
            if success{
                print("消息保存成功!")
            }else{
                
                print("消息保存失败! \(error)")
                
            }
        }
        
    }
    func deleteMessage(message:PFObject){
message.deleteInBackgroundWithBlock { (success, error) -> Void in
        guard  error == nil else{
            print("保存失败! \(error?.userInfo)")
            return
    
            }
            print("保存成功!")
        }
    
    }

    func sendAction() {
        var question = ""
        var answer = ""
        
        let message = Message(incoming: false, text: textView.text, sentDate: NSDate())
        saveMessage(message)

        
        question = textView.text
        
        
        textView.text = nil
        updateTextViewHeight()
        sendButton.enabled = false
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow:tableView.numberOfRowsInSection(0), inSection:0)
            ], withRowAnimation: .Left)
        self.tableView.endUpdates()
        self.tableViewScrollToBottomAnimated(false)
        
        Alamofire.request(.GET, NSURL(string: api_url)!, parameters: ["key":api_key,"info":question,"userid":PFUser.currentUser()!.objectId! as String]).responseJSON(options: NSJSONReadingOptions.MutableContainers) { _,_,data   in
            
            
            guard data.isSuccess else{
                print("Data read error \(data.error)")
                return
            }
            
            guard let text = data.value!.objectForKey("text") as? String else{
                print("Text is nil!")
                return
            }
            answer = text
            if let url = data.value!.objectForKey("url") as? String {
                let message = Message(incoming: true,
                    text:text+"\n(点击该消息打开查看)",
                    sentDate: NSDate())
                message.url = url
                self.saveMessage(message)

                self.createUserActivity(self.messageObjects.count - 1, question: question, answer:answer, url: url)
                
            }else{
                
                let message = Message(incoming: true, text:text, sentDate: NSDate())
                self.saveMessage(message)

                self.createUserActivity(self.messageObjects.count - 1 , question: question, answer:answer, url:"")
                
            }
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([
                NSIndexPath(forRow:self.tableView.numberOfRowsInSection(0) , inSection:0)
                ], withRowAnimation:.Left)
            self.tableView.endUpdates()
            self.tableViewScrollToBottomAnimated(false)
            
        }
        
    }
    func createUserActivity(index:Int,question:String,answer:String,url:String){
        let myActivity = NSUserActivity(activityType: "com.codeGlider.TuringChatMachine.chat")//1
        myActivity.title = "Q:\(question)\nA:\(answer)" // 2
        myActivity.eligibleForSearch = true // 4
        
        myActivity.keywords = Set(arrayLiteral:question,answer) // 5
        self.userActivity = myActivity // 6
        if url != ""{
            self.userActivity?.userInfo = ["index":index]
            self.userActivity?.webpageURL = NSURL(string: url)
        }else{
            self.userActivity?.userInfo = ["index":index]
        }
        myActivity.eligibleForHandoff = false // 7
        myActivity.becomeCurrent() // 8
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        continuedActivity = activity
        if let index = continuedActivity!.userInfo!["index"] as? Int {
            
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:index, inSection:0), atScrollPosition: .Middle, animated: true)
        }
        
        if let url = continuedActivity?.webpageURL{
            let webVC = SFSafariViewController(URL:url, entersReaderIfAvailable: true)
            webVC.delegate = self
            self.presentViewController(webVC, animated: true, completion: nil)
        }
        super.restoreUserActivityState(activity)
    }
    
    func tableViewScrollToBottomAnimated(animated: Bool) {
        
        
        let numberOfRows = tableView.numberOfRowsInSection(0)
        if numberOfRows > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:numberOfRows - 1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
    }
    func updateTextViewHeight() {
        let oldHeight = textView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.max)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
            #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        if newHeight != oldHeight {
            toolBar.frame.size.height = newHeight+8*2-0.5
        }
    }
    //MARK:键盘弹出监控方法
    func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height
        let insetOld = tableView.contentInset
        let insetChange = insetNewBottom - insetOld.bottom
        let overflow = tableView.contentSize.height - (tableView.frame.height-insetOld.top-insetOld.bottom)
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations: (() -> Void) = {
            if !(self.tableView.tracking || self.tableView.decelerating) {
                // 根据键盘位置调整Inset
                if overflow > 0 {
                    self.tableView.contentOffset.y += insetChange
                    if self.tableView.contentOffset.y < -insetOld.top {
                        self.tableView.contentOffset.y = -insetOld.top
                    }
                } else if insetChange > -overflow {
                    self.tableView.contentOffset.y += insetChange + overflow
                }
            }
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16)) // http://stackoverflow.com/a/18873820/242933
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height
        
        // Inset `tableView` with keyboard
        let contentOffsetY = tableView.contentOffset.y
        tableView.contentInset.bottom = insetNewBottom
        tableView.scrollIndicatorInsets.bottom = insetNewBottom
        // Prevents jump after keyboard dismissal
        if self.tableView.tracking || self.tableView.decelerating {
            tableView.contentOffset.y = contentOffsetY
        }
    }
    
    
    func itemWithImage(image:String,highlightImage:String,target:AnyObject,action:Selector)->UIBarButtonItem
    {
        let button = UIButton(type: UIButtonType.Custom)
        button.setBackgroundImage(UIImage(named: image), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: highlightImage), forState: UIControlState.Highlighted)
        
        button.frame = CGRect(origin: CGPointZero, size: (UIImage(named: image)?.size)!)
        
        button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
class InputTextView: UITextView {
    
    
    
}
