//  Created by MyCom on 7/11/17.
//  Copyright © 2017 Mexonis. All rights reserved.


import UIKit
import Firebase
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
import OneSignal
import Fabric
import Crashlytics
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {
    
    var window: UIWindow?
    var postTimer: Timer?
    let gcmMessageIDKey = "gcm.message_id"
    // Stores reference on PubNub client to make sure what it won't be released.
    var client: PubNub!
    fileprivate let defaults:UserDefaults = UserDefaults.standard;
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "3ebeaee3-78d1-44bb-92b7-f21c6e68040c", handleNotificationReceived: { (notification) in
            
        }, handleNotificationAction: { (result) in
            let payload: OSNotificationPayload? = result?.notification.payload
            print(payload ?? "")
            
        }, settings: [kOSSettingsKeyInFocusDisplayOption: OSNotificationDisplayType.none.rawValue])
        
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        let configuration = PNConfiguration(publishKey: "demo", subscribeKey: "demo")
        self.client = PubNub.clientWithConfiguration(configuration)
        
        self.client.addListener(self)
        self.client.subscribeToChannels(["my_channel1","my_channel2"], withPresence: false)
        
        
        
        if (defaults.object(forKey: "instr_0_out") == nil){
            
            
            defaults.set("midi_clock_none", forKey: "midi_sync");
            defaults.set(0, forKey: "instr_0_out");
            defaults.set(1, forKey: "instr_1_out");
            defaults.set(2, forKey: "instr_2_out");
            defaults.set(3, forKey: "instr_3_out");
            defaults.set(4, forKey: "instr_4_out");
            defaults.set(5, forKey: "instr_5_out");
            defaults.set(6, forKey: "instr_6_out");
            
            defaults.set(true, forKey: "age")
            defaults.set(true, forKey: "gender")
            defaults.set(true, forKey: "religion")
            defaults.set(true, forKey: "height")
            defaults.set(true, forKey: "weight")
            defaults.set(true, forKey: "race")
            defaults.set(true, forKey: "eyecolor")
            
            defaults.set("slender", forKey: "appearance")
            defaults.set("Dallas", forKey: "citystate")
            
        }

        
        FirebaseApp.configure()
        
        
        GMSServices.provideAPIKey("AIzaSyDRyJ6xtZN5Mh7L_QxX8phHS1ML4KI3d_Y")
        
        GMSPlacesClient.provideAPIKey("AIzaSyDRyJ6xtZN5Mh7L_QxX8phHS1ML4KI3d_Y")
    
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        UINavigationBar.appearance().isTranslucent = false
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN = \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){
//        
//
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
//        
//        completionHandler(UIBackgroundFetchResult.newData)
//
//        
//    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Firebase registration token")

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.channel != message.data.subscription {
            
            // Message has been received on channel group stored in message.data.subscription.
        }
        else {
            
            // Message has been received on channel stored in message.data.channel.
        }
        
        print("Received message: \(String(describing: message.data.message)) on channel \(message.data.channel) " +
            "at \(message.data.timetoken)")
    }
    
    // Handle subscription status change.
    func client(_ client: PubNub, didReceive status: PNStatus) {
        
        if status.operation == .subscribeOperation {
            
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    
                    // This is expected for a subscribe, this means there is no error or issue whatsoever.
                }
                else {
                    
                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {
                
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {
                
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {
                    
                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                }
                else {
                    
                    /**
                     More errors can be directly specified by creating explicit cases for other error categories
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                }
            }
        }
        else if status.operation == .unsubscribeOperation {
            
            if status.category == .PNDisconnectedCategory {
                
                /**
                 This is the expected category for an unsubscribe. This means there was no error in
                 unsubscribing from everything.
                 */
            }
        }
        else if status.operation == .heartbeatOperation {
            
            /**
             Heartbeat operations can in fact have errors, so it is important to check first for an error.
             For more information on how to configure heartbeat notifications through the status
             PNObjectEventListener callback, consult http://www.pubnub.com/docs/ios-objective-c/api-reference-configuration#configuration_basic_usage
             */
            
            if !status.isError { /* Heartbeat operation was successful. */ }
            else { /* There was an error with the heartbeat operation, handle here. */ }
        }
    }
    
    
    
    
}




