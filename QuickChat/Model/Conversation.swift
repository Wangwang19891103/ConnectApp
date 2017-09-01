//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import UserNotifications

class Conversation {
    
    //MARK: Properties
    let user: User
    var lastMessage: Message
    
    //MARK: Methods
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
            notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
            notification.alertAction = "be awesome!"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["CustomField1": "w00t"]
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
        if let currentUserID = Auth.auth().currentUser?.uid {
            var conversations = [Conversation]()
            Database.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    let fromID = snapshot.key
                    let values = snapshot.value as! [String: String]
                    let location = values["location"]!
                    User.info(forUserID: fromID, completion: { (user) in
                        let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                        conversations.append(conversation)
                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
                            completion(conversations)
                        })
                    })
                }
            })
        }
    }
    
    //MARK: Inits
    init(user: User, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
}
