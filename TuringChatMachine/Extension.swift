//
//  Extension.swift
//  ParseDemo
//
//  Created by codeGlider on 15/9/19.
//  Copyright © 2015年 abearablecode. All rights reserved.
//

import UIKit
import SnapKit

extension String{
    func getLength()->Int{
        return (self as NSString).length
        
    }
    
}
extension UITextField{

    func addTextFieldLeftView(withImageName:String,withLeftPandding:CGFloat,andRightPandding:CGFloat){
        let panddingInset = UIEdgeInsets(top: 0, left:withLeftPandding, bottom: 0, right:andRightPandding)
        let userLeftView = UIImageView(image: UIImage(named:withImageName)!)
        userLeftView.contentMode = .ScaleAspectFit
        let sidePanddingView = UIView(frame: CGRect(x: 0, y: 0, width:userLeftView.frame.width + panddingInset.left + panddingInset.right, height: userLeftView.frame.height))
        sidePanddingView.backgroundColor = UIColor.clearColor()
        sidePanddingView.addSubview(userLeftView)
        userLeftView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(sidePanddingView.snp_left).offset(panddingInset.left)
            make.right.equalTo(sidePanddingView.snp_right).offset(-panddingInset.right)
            make.centerY.equalTo(sidePanddingView.snp_centerY)
        }
        
        self.leftView = sidePanddingView
        self.leftViewMode = .Always
        
        
    }
}
func formatDate(date: NSDate) -> String {
    let calendar = NSCalendar.currentCalendar()
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
    
    let last18hours = (-18*60*60 < date.timeIntervalSinceNow)
    let isToday = calendar.isDateInToday(date)
    let isYesteday = calendar.isDateInYesterday(date)
    let isLast7Days = (calendar.compareDate(NSDate(timeIntervalSinceNow: -7*24*60*60), toDate: date, toUnitGranularity: NSCalendarUnit.NSDayCalendarUnit) == NSComparisonResult.OrderedAscending)
    
    
    if last18hours || isToday {
        dateFormatter.dateFormat = "a HH:mm"
    }else if isYesteday{
        dateFormatter.dateFormat = "昨天 a HH:mm"
    }
    else if isLast7Days {
        dateFormatter.dateFormat = "EEEE a HH:mm"
    } else {
        dateFormatter.dateFormat = "YYYY年MM月dd日 a HH:mm"
        
    }
    return dateFormatter.stringFromDate(date)
}
 