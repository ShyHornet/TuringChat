//
//  TRChatRequestManager.swift
//  TuringChatMachine
//
//  Created by codeGlider on 15/10/8.
//  Copyright © 2015年 codeGlider. All rights reserved.
//

import Foundation
import Alamofire
import Parse

typealias newsType = (article:String,detailurl:String,icon:String,source:String)
typealias trainsType = (detailurl:String,endtime:String,icon:String,start:String,starttime:String,terminal:String,trainnum:String)
typealias recipeType = (name:String,info:String,detailurl:String,icon:String)

public enum messageType:String{
        case text = "100000"
        case link = "200000"
        case news = "302000"
        case trains = "305000"
        case recipes = "308000"
        
    }

public class TRChatRequestManager{
    
    

    
    
    public var type:messageType!
    public var message:AnyObject!
    private static let instance = TRChatRequestManager()
    class var sharedManager:TRChatRequestManager {
        
        return instance
    }
    func requestMessage(question:String,handler:(type:messageType,message:AnyObject)->Void){
        
        Alamofire.request(.GET, NSURL(string: api_url)!, parameters: ["key":api_key,"info":question,"userid":PFUser.currentUser()!.objectId! as String]).responseJSON(options: NSJSONReadingOptions.MutableContainers) { _,_,data   in
            
            guard data.isSuccess else{
                print("Request error \(data.error)")
                return
            }
            
            guard let type  = messageType.init(rawValue:((data.value!.objectForKey("code") as? NSNumber)?.stringValue)! ) else{
                print("Data  error \(data.error)")
                return
            }
            guard let answer = data.value!.objectForKey("text") as? String else {
                print("Data  error \(data.error)")
                return
            
            }
            
            self.type = type
            
            switch (type){
                
            case .text:
                
                let message = textMessage(answer: answer)
                
                self.message = message
                print("\(self.type) : \((self.message as! textMessage).answer)")
                handler(type: type, message: self.message as! textMessage)
                break
            case .link:
               
                let url = data.value!.objectForKey("url") as! String
                let message = linkMessage(answer: answer + "\n(请点击本消息打开查看)", url: url)
                self.message = message
                print("\(self.type) : \(self.message as! linkMessage)")
                handler(type: type, message: self.message as! linkMessage)
                break
            case .trains:

                var trains:[trainsType] = []
                
                (data.value!.objectForKey("list") as! NSArray)
                    .map{
                        trains.append((
                            $0.objectForKey("detailurl") as! String ,
                            $0.objectForKey("endtime") as! String,
                            $0.objectForKey("icon") as! String,
                            $0.objectForKey("start") as! String,
                            $0.objectForKey("starttime") as! String,
                            $0.objectForKey("terminal") as! String,
                            $0.objectForKey("trainnum") as! String
                            )
                        )
                        
                }
                self.message = trainMessage(answer: answer, trains: trains)
                handler(type: type, message: self.message as! trainMessage)
               // print("\(self.type) : \((self.message as! trainMessage).trains)")
                break
            case .news:

                var  news:[newsType] = []
                
                (data.value!.objectForKey("list") as! NSArray)
                    .map{
                        news.append((
                            $0.objectForKey("article") as! String ,
                            $0.objectForKey("detailurl") as! String,
                            $0.objectForKey("icon") as! String,
                            $0.objectForKey("source") as! String)
                        )
                    
                }
                self.message = newsMessage(answer: answer, news: news)
//                print("\(self.type) : \((self.message as! newsMessage).news)")
                break
            case .recipes:
                var recipes:[recipeType] = []
                
                (data.value!.objectForKey("list") as! NSArray)
                    .map{
                        recipes.append((
                            $0.objectForKey("name") as! String ,
                            $0.objectForKey("info") as! String,
                            $0.objectForKey("detailurl") as! String,
                            $0.objectForKey("icon") as! String
                            )
                        )
                        
                }
                self.message = recipeMessage(answer: answer, recipes: recipes)
                
//                print("\(self.type) : \((self.message as! recipeMessage).recipes)")
                break
            default: break
                
                
            }
            
            
        }
        
     
        
    }
    
    
    
}
class textMessage{
    
    var answer:String
    init( answer:String){
        
        self.answer = answer
        
    }
    
    
}
class linkMessage{
    var answer:String
    var url:String
    init(answer:String,url:String){
        
        self.answer = answer
        self.url  = url
        
    }
    
}
class newsMessage{
    var answer:String
    var news:[newsType]
    init(answer:String,news:[newsType]){
        self.answer = answer
        self.news = news
    }
    
}
class recipeMessage{
    var answer:String
    var recipes:[recipeType]
    init(answer:String,recipes:[recipeType]){
        self.answer = answer
        self.recipes = recipes
    
    }
}
class trainMessage{
    var answer:String
    var trains:[trainsType]
    init(answer:String,trains:[trainsType]){
        self.answer = answer
        self.trains = trains
        
        
    }
    
}
    
