//
//  NewsTableViewCell.swift
//  TuringChatMachine
//
//  Created by codeGlider on 15/10/10.
//  Copyright © 2015年 codeGlider. All rights reserved.
//

import UIKit
import SnapKit

class MutiMessageTableViewCell: UITableViewCell,UITableViewDataSource,UITableViewDelegate{
    var tableView:UITableView
    var message:Message!
    let sentDateLabel:UILabel
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.layer.borderWidth = 1
        tableView.layer.shadowColor = UIColor.grayColor().CGColor
        tableView.layer.shadowRadius = 1
        tableView.layer.shadowOffset = CGSize(width: 1,height: 1)
        
        sentDateLabel = UILabel(frame: CGRectZero)
        sentDateLabel.font = UIFont.systemFontOfSize(sentDateFontSize)
        sentDateLabel.numberOfLines = 1
        sentDateLabel.userInteractionEnabled = false
        sentDateLabel.textAlignment = .Center
        sentDateLabel.textColor = UIColor(red:0.95, green:0.98, blue:0.99, alpha:1)
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(tableView)
        contentView.addSubview(sentDateLabel)
        
        sentDateLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(6)
            make.centerX.equalTo(contentView.snp_centerX)
            
        }
        tableView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(sentDateLabel.snp_bottom).offset(6)
            make.width.equalTo(200)
            make.centerX.equalTo(contentView.snp_centerX)
            make.bottom.equalTo(contentView.snp_bottom).offset(-4.5)
            
            
            
        }
        
        
        
        
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureWithMutiMessage(message:Message,showSentDate:Bool){
        if showSentDate {
        sentDateLabel.text = formatDate(message.sentDate)
        }
    self.message = message
    self.tableView.delegate = self
    self.tableView.dataSource = self
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
      func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (message.messageType){
        case messageType.trains.rawValue:
            return (message.contents as! [trainsType]).count
        case messageType.news.rawValue:
             return (message.contents as! [newsType]).count
        case messageType.recipes.rawValue:
             return (message.contents as! [recipeType]).count
        default:
            return 0
        }
        
       
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if cell == nil {
         cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        
        }
        if message.messageType == messageType.news.rawValue{
            let news  = message.contents as! [newsType]
            
            cell?.textLabel?.text = "\(news[indexPath.row].article)"
        
        }
        else if message.messageType == messageType.trains.rawValue{
            let trains  = message.contents as! [trainsType]
            
        cell?.textLabel?.text = "\(trains[indexPath.row].start)->\(trains[indexPath.row].terminal) \(trains[indexPath.row].trainnum) \n\(trains[indexPath.row].starttime) - \(trains[indexPath.row].endtime)"
           
        }
        else if message.messageType == messageType.recipes.rawValue{
            let recipes  = message.contents as! [recipeType]
            
            cell?.textLabel?.text = "\(recipes[indexPath.row].name)"
            
        }
        return cell!
    }

    
}


