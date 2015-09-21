import Foundation.NSDate

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
