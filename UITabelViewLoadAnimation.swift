

import Foundation
import UIKit
enum AnimationDirect{
    case DropDownFromTop
    case LiftUpFromBottum
    case FromRightToLeft
    case FromLeftToRight
}
extension UITableView {
    /**
    *  UITableView重新加载动画
    *
    *  @param   direct    cell运动方向
    *  @param   time      动画持续时间，设置成1.0
    *  @param   interval  每个cell间隔，设置成0.1
    *  @example self.tableView.reloadDataWithAnimate(AnimationDirect.DropDownFromTop, animationTime: 0.5, interval: 0.05)
    */
    func reloadDataWithAnimate(direct:AnimationDirect,animationTime:NSTimeInterval,interval:NSTimeInterval)->Void{
        self.setContentOffset(self.contentOffset, animated: false)
        UIView.animateWithDuration(0.2, delay: 1.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
       
           self.hidden = true
          
            self.reloadData()
            }) {(finished) -> Void in
                self.hidden = false
              
                self.visibleRowsBeginAnimation(direct, animationTime: animationTime, interval: interval)
        }
        
    }
    func visibleRowsBeginAnimation(direct:AnimationDirect,animationTime:NSTimeInterval,interval:NSTimeInterval)->Void{
        let visibleArray : NSArray = self.indexPathsForVisibleRows! as NSArray
        let count =  visibleArray.count
        switch direct{
        case .DropDownFromTop:
            for i in 0...(count-1){
                let path : NSIndexPath = visibleArray.objectAtIndex(count - 1 - i) as! NSIndexPath
                let cell : UITableViewCell = self.cellForRowAtIndexPath(path)!
                cell.hidden = true
                let originPoint : CGPoint = cell.center
                cell.center = CGPointMake(originPoint.x, originPoint.y - 1000)
                UIView.animateWithDuration(animationTime + NSTimeInterval(i) * interval, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    cell.center = CGPointMake(originPoint.x ,  originPoint.y + 2.0)
                    cell.hidden = false
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            cell.center = CGPointMake(originPoint.x ,  originPoint.y - 2.0)
                            }, completion: { (finished) -> Void in
                                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    cell.center = originPoint
                                    }, completion: { (finished) -> Void in
                                        
                                })
                        })
                        
                })
            }
        case .LiftUpFromBottum:
            for i in 0...(count-1){
                var path : NSIndexPath = visibleArray.objectAtIndex(i) as! NSIndexPath
                var cell : UITableViewCell = self.cellForRowAtIndexPath(path)!
                cell.hidden = true
                let originPoint : CGPoint = cell.center
                cell.center = CGPointMake(originPoint.x, originPoint.y + 1000)
                UIView.animateWithDuration(animationTime + NSTimeInterval(i) * interval, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.center = CGPointMake(originPoint.x ,  originPoint.y - 2.0)
                    cell.hidden = false
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            cell.center = CGPointMake(originPoint.x ,  originPoint.y + 2.0)
                            }, completion: { (finished) -> Void in
                                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    cell.center = originPoint
                                    }, completion: { (finished) -> Void in
                                        
                                })
                        })
                })
            }
        case .FromLeftToRight:
            
            for i in 0...(count-1){
                var path : NSIndexPath = visibleArray.objectAtIndex(i) as! NSIndexPath
                var cell : UITableViewCell = self.cellForRowAtIndexPath(path)!
                cell.hidden = true
                let originPoint : CGPoint = cell.center
                cell.center = CGPointMake(-cell.frame.size.width,  originPoint.y)
                UIView.animateWithDuration(animationTime + NSTimeInterval(i) * interval, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.center = CGPointMake(originPoint.x - 2.0,  originPoint.y)
                    cell.hidden = false;
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            cell.center = CGPointMake(originPoint.x + 2.0,  originPoint.y)
                            }, completion: { (finished) -> Void in
                                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    cell.center = originPoint
                                    }, completion: { (finished) -> Void in
                                        
                                })
                        })
                })
                
            }
        case .FromRightToLeft:
            for i in 0...(count-1){
                var path : NSIndexPath = visibleArray.objectAtIndex(i) as! NSIndexPath
                var cell : UITableViewCell = self.cellForRowAtIndexPath(path)!
                cell.hidden = true
                let originPoint : CGPoint = cell.center
                cell.center = CGPointMake(cell.frame.size.width * 3.0,  originPoint.y)
                UIView.animateWithDuration(animationTime + NSTimeInterval(i) * interval, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    cell.center = CGPointMake(originPoint.x + 2.0,  originPoint.y)
                    cell.hidden = false;
                    }, completion: { (finished) -> Void in
                        UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                            cell.center = CGPointMake(originPoint.x - 5.0,  originPoint.y)
                            }, completion: { (finished) -> Void in
                                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                                    cell.center = originPoint
                                    }, completion: { (finished) -> Void in
                                        
                                })
                        })
                })
                
            }
        default:
            return
        }
        
    }
    
}
