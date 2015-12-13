import Foundation.NSDate
import Parse

class Message {
    let incoming: Bool
    let text: String
    let sentDate: NSDate
    let messageType:String
    var contents:NSData
    var url = ""
    init(messageType:String,incoming: Bool, text: String,contents:NSData, sentDate: NSDate) {
        self.incoming = incoming
        self.text = text
        self.sentDate = sentDate
        self.messageType = messageType
        self.contents = contents
        
        
   }
    
}
