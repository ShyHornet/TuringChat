![iOS9版本](http://upload-images.jianshu.io/upload_images/727794-67116a10f9ddb2ee.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#本篇文章你将学到
- 将我们的app更新到iOS9过程中的一些问题和解决办法
- 使用`swift2.0`的新语法`guard`对项目代码进行优化和修改
- 使用iOS9的新组件`SFSafariViewController`快速实现内置浏览器
...更多iOS9新功能的使用我会在研究出来之后和大家分享的~敬请关注！

>本篇文章的初始代码下载(已进行ios9适配):
[百度网盘地址](http://pan.baidu.com/s/1ntF0VMD)

我们的app终于步入iOS9时代了~我对我们的app进行了iOS9适配，当然在这个过程中会有一些问题，(**其实蛮蛋疼的=  =**)下面我先跟大家分享一下其中的问题及其解决办法:
首先我们app的第三方库并不支持iOS9,所以我们要对cocoapods的配置文件进行更新:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘8.0’
use_frameworks!

pod 'Alamofire','~> 2.0'//原来是1.3版本
pod 'SnapKit', '~> 0.14.0'//原来是0.12版本
pod 'Parse','~>1.7.1'
pod 'ParseUI','~>1.1.3'
```
将当前目录更改到项目目录:
```
$ cd <项目目录>
```
然后调用cocoa pods更新命令:
```
$ pod update
```
其中Alamofire库已经发生了改变,所以使用上会有一些变化，我们来看一看**ChatViewController.swift**中的376行,也就是**sendAction()**方法中调用api得到机器人回复的地方。
这是以前:
```swift
        Alamofire.request(.GET, NSURL(string: api_url)!, parameters: ["key":api_key,"info":question,"userid":userId])
        .responseJSON(options: NSJSONReadingOptions.MutableContainers) { (_,_,data,error) -> Void in
           
            if error == nil{
                if let text = data!.objectForKey(textKey) as? String{
                    
                    if let url = data!.objectForKey(urlKey) as? String{
                        var message = Message(incoming: true, text:text+"\n(点击该消息打开查看)", sentDate: NSDate())
                        message.url = url
                        self.saveMessage(message)
                        self.messages[lastSection].append(message)
                    }else{
                        var message = Message(incoming: true, text:text, sentDate: NSDate())
                        self.saveMessage(message)
                        self.messages[lastSection].append(message)
                    }
                    
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([
                        NSIndexPath(forRow: 2, inSection: lastSection)
                        ], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    self.tableViewScrollToBottomAnimated(true)
                }
            }else{
                println("Error occured! \(error?.userInfo)")
            }
            
        }
```
更新之后:
```
        Alamofire.request(.GET, NSURL(string: api_url)!, parameters: ["key":api_key,"info":question,"userid":userId])
        .responseJSON(options: NSJSONReadingOptions.MutableContainers) { _,_,data   in
           
            if data.isSuccess {
                if let text = data.value!.objectForKey("text") as? String{
                    
                    if let url = data.value!.objectForKey("url") as? String{
                        let message = Message(incoming: true, text:text+"\n(点击该消息打开查看)", sentDate: NSDate())
                        message.url = url
                        self.saveMessage(message)
                        self.messages[lastSection].append(message)
                    }else{
                        let message = Message(incoming: true, text:text, sentDate: NSDate())
                        self.saveMessage(message)
                   self.messages[lastSection].append(message)
                    }
                    
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([
                        NSIndexPath(forRow: 2, inSection: lastSection)
                        ], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    self.tableViewScrollToBottomAnimated(false)
                    
                }
            }else{
            print("Data read error \(data.error)")
            }
            
        }
```
其中的差别是responseJSON方法中用来处理结果的闭包类型由
```
(NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?)-> Void
```
变为了:
```
(NSURLRequest?, NSHTTPURLResponse?, Result<AnyObject>) -> Void
```
少了一个参数，因为它把后两个参数集成到一个枚举类型里了，同时包含的数据和错误信息:


|名称|类型|说明|
|--|--|--|
|Value|AnyObject|用来存储数据信息|
|isSuccess|Bool|告诉我们请求是否成功|
|isFailuere|Bool|isSuccess取反，即请求是否失败|
|error|NSError|如果请求不成功的话就会有值，存储具体的错误，否则就是nil|
所以我们的流程就要变了，首先判断请求是否成功:
```
 if data.isSuccess {

//处理数据data.value
}else{
//打印错误信息data.error
}
```
但是上面的代码还不是我们的最终代码，因为可以swift2.0的新语法`guard`来优化一下这里。
`guard`顾名思义，有警卫、控制的意思，实际上和条件控制语句`if`有异曲同工之处,当满足一定条件时，会对应执行一些操作，我们把上面的流程改变为`guard`的版本:
```
guard data.isSuccess else{
//打印错误信息data.error
return
}
 //处理数据data.value
```
如果`data.isSuccess`条件满足，不会进入到else的大括号区域，而是不做任何事情，继续执行下面的语句，也就是“通过了警卫的检查”，然而如果该条件不满足就会进入到else大括号区域，也就是“被带到了警卫室进行处理= =”，那么就是打印错误信息，然后终止运行，不会执行下面的语句。大家应该明白了guard的用法了吧，是不是很好理解？
大家可以看到我使用了很多`if-let`模式的语法进行数据拆包，而且是层层嵌套，而这里的数据拆包操作guard也可以完成，而且会使代码变得更容易理解,比如第一个拆包操作:
```swift
 if let text = data.value!.objectForKey("text") as? String{
//对数据进行处理
}
```
`guard`版本:
```
 guard let text = data.value!.objectForKey("text") as? String else{
    return
}
//对数据进行处理
```
这里我们可以看出用guard拆包的一些特性和优点:
如以上代码所示，guard拆包所使用的text常量，在下文可以使用，而不是像if一样，text的作用域只是局限在大括号中。
这样的好处就是你不需要用大括号包裹你的处理代码，这样代码层次就减少了，不需要嵌套，这样既提高了代码可维护性也提高了可阅读性。
那么下面就用guard来优化一下Alamofire的代码吧！
首先确保请求成功:
```
  guard data.isSuccess else{
                print("Data read error \(data.error)")
                return
            }
```
然后确保消息内容成功解包:
```
            guard let text = data.value!.objectForKey("text") as? String else{
                print("Text is nil!")
                return
            }
```
但是解包url的过程还是使用`if-let`进行解包，因为url无论是否存在都会执行向`tableView`添加新消息的操作，如果使用`guard`就会导致代码的冗余。
优化后代码:
```
        Alamofire.request(.GET, NSURL(string: api_url)!, parameters: ["key":api_key,"info":question,"userid":userId])
        .responseJSON(options: NSJSONReadingOptions.MutableContainers) { _,_,data   in
            
            
            guard data.isSuccess else{
                print("Data read error \(data.error)")
                return
            }
            
            guard let text = data.value!.objectForKey("text") as? String else{
                print("Text is nil!")
                return
            }
         
          if let url = data.value!.objectForKey("url") as? String {
            let message = Message(incoming: true,
                text:text+"\n(点击该消息打开查看)",
                sentDate: NSDate())
            message.url = url
            self.saveMessage(message)
            self.messages[lastSection].append(message)

          }else{
       
          let message = Message(incoming: true, text:text, sentDate: NSDate())
                self.saveMessage(message)
                self.messages[lastSection].append(message)
            self.saveMessage(message)
            self.messages[lastSection].append(message)

            }
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([
                NSIndexPath(forRow: 2, inSection: lastSection)
                ], withRowAnimation: .Automatic)
            self.tableView.endUpdates()
            self.tableViewScrollToBottomAnimated(false)
            
        }

    }
```
很明显可以感觉到这段代码清爽很多，减少了2层的嵌套,`guard`功不可没！
接下来运行一下，你会发现这段网络请求代码好像失效了:
```
App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.
```
iOS9把所有的http请求都改为https了,而我们聊天机器人的api还是使用的http，那么怎么解决呢？
有两种办法,一是修改服务器代码，使之使用加密的https请求，当然这不可能实现。。。因为我还没有那么高超的技术可以黑服务器！😁哈哈哈开玩笑，我们来看看第二种办法，这是一个临时的办法，就是像错误里所说的，在**Info.plost**设置临时的例外，下面我们就去这样做。
打开工程的**Supporting Files**文件夹中的**Info.plist**:

![屏幕快照 2015-09-21 上午10.35.45.png](http://upload-images.jianshu.io/upload_images/727794-a7886e39e58dac95.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
增加一个条目:

![屏幕快照 2015-09-21 上午10.37.23.png](http://upload-images.jianshu.io/upload_images/727794-38da0df4294c36de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
名字写`NSAppTransportSecurity`,类型`Dictionary`:
![屏幕快照 2015-09-21 上午10.38.36.png](http://upload-images.jianshu.io/upload_images/727794-3169446d62b0b19a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
在该字典中添加新条目,名称`NSAllowsArbitraryLoads`，类型`Boolean`:

![屏幕快照 2015-09-21 上午10.39.06.png](http://upload-images.jianshu.io/upload_images/727794-0ff2000e2522f251.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
将value改为YES,都做完之后应该像这样:

![屏幕快照 2015-09-21 上午10.45.04.png](http://upload-images.jianshu.io/upload_images/727794-ae9356953754db15.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
然后我们再次运行，应该没有上面的错误了！
你会发现我们的升级版还多了一个文件:**WebViewController.swift**，这里实现了一个微型浏览器，用来响应url的点击事件,打开后像这样:

![Simulator Screen Shot 2015年9月21日 上午10.17.25.png](http://upload-images.jianshu.io/upload_images/727794-ecde514b13845ec6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
左上角实现了网页回退和前进，右上角实现了退出功能，这是ios8实现一个内嵌浏览器的办法,虽然也有其他更好的办法比如WebKit，但我想向大家展示的是最为简单也是最新的办法，使用SFSafariViewController:

![SFSafariViewController](http://upload-images.jianshu.io/upload_images/727794-ee1455754560cb70.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
首先打开**ChatViewController.swift**,在文件开头增加引用:
```
import SafariServices
```
使我们的类遵循`SFSafariViewControllerDelegate`协议:
```swift
class ChatViewController:UITableViewController,UITextViewDelegate,SFSafariViewControllerDelegate{
//////////////////
}
```
找到响应消息点击的方法:
```
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? MessageBubbleTableViewCell{
            if selectedCell.url != ""{
               let webVC = WebViewController(url: selectedCell.url)
                self.presentViewController(webVC, animated: true, completion: nil)
               

            }
        }
```
我们也可以现对它使用guard语句进行优化:
```
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        guard let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? MessageBubbleTableViewCell else{
            return nil
        }
        
        guard selectedCell.url != "" else{
            return nil
        }
         let webVC = WebViewController(url: selectedCell.url)
                self.presentViewController(webVC, animated: true, completion: nil)
        return nil
    }
```
使用新的`SFSafariViewController`类:
```
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
            webVC.navigationItem.rightBarButtonItem?.title = "完成"
            self.presentViewController(webVC, animated: true, completion: nil)
        } else {
            let webVC = WebViewController(url: selectedCell.url)
            self.presentViewController(webVC, animated: true, completion: nil)
            
        }
        
        return nil
    }
```
注意到我们使用了 `if #available(iOS 9.0, *)`判断，只有在iOS9系统中才使用新的组件，否则还是使用以前自定义浏览器的方式，我们还自定义了它的返回键显示中文的完成(否则显示Done)，然后还有一点需要注意，那就是这一行代码一定要加上:
```
webVC.delegate = self
```
然后实现`SFSafariViewController`的关闭方法:
```
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
```
这样就可以了，我们来运行一下看看效果:

![运行结果](http://upload-images.jianshu.io/upload_images/727794-5f7cb4b4b428fc3a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
可以看出这个组件非常强大，实现了浏览器的几乎所有功能，这些按钮也可以根据自己的需要进行定制。
下一节我们将学习如何使用iOS9新的搜索API实现在搜索栏输入聊天关键词滚动到对应的位置，还有自定义一个好看的登陆界面(包括欢迎、登陆、注册新用户、密码找回)!

![登陆界面套装](http://upload-images.jianshu.io/upload_images/727794-c7b9d4e236b9c53b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
已经将最新版本托管到github，欢迎大家点✨~
[github托管地址](https://github.com/ShyHornet/TuringChat)
