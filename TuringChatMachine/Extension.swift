//
//  Extension.swift
//  ParseDemo
//
//  Created by codeGlider on 15/9/19.
//  Copyright © 2015年 abearablecode. All rights reserved.
//

import UIKit

extension String{
    func getLength()->Int{
        return (self as NSString).length
        
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
 