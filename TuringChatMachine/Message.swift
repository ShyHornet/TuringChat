import Foundation.NSDate
import Parse

class Message {
    let incoming: Bool
    let text: String
    let sentDate: NSDate
    var url = ""
    init(incoming: Bool, text: String, sentDate: NSDate) {
        self.incoming = incoming
        self.text = text
        self.sentDate = sentDate
    }
}
class MessageObject:PFObject,PFSubclassing{
    @NSManaged var incoming:Bool
    @NSManaged var text:String
    @NSManaged var sentDate:NSDate
    @NSManaged var url:String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    
    static func parseClassName() -> String {
        return "Message"
    }

}
