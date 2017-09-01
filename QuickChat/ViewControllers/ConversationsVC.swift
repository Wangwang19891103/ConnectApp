//  Created by MyCom on 7/11/17.
//  Copyright © 2017 Mexonis. All rights reserved.

import UIKit
import Firebase
import AudioToolbox
import CoreLocation
import UserNotifications
import OneSignal


class ConversationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    //MARK: Properties //UINavigationControllerDelegate
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var findConnectButton: RoundedButton!
    @IBOutlet weak var alertBottomConstraint: NSLayoutConstraint!
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "setting3")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(ConversationsVC.sideBarMenu))
        return button
    }()
    var items = [Conversation]()
    var selectedUser: User?
    var locationFlag = false
    
    var isGrantedNotificationAccess:Bool = false

    // Location Manager - CoreLocation Framework
    var locationManager = CLLocationManager()
    
    // Current location information
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var backgroundTimer: Timer!
    var appDelegate: AppDelegate!
    
    // Time intervals for scan
    var timeInMinutes: TimeInterval!
    
    // BackgroundTaskIdentifier for background update location
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    var backgroundTaskIdentifier2: UIBackgroundTaskIdentifier!
    
    var locationCoordinateArray = [CLLocationCoordinate2D]()
    
    
    func customization()  {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont, NSForegroundColorAttributeName: UIColor.white]
        // notification setup
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showEmailAlert), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        //right bar button
        let icon = UIImage.init(named: "compose")?.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(ConversationsVC.showContacts))
        self.navigationItem.rightBarButtonItem = rightButton
        //left bar button image fetching
        let image = UIImage.init(named: "setting1")?.withRenderingMode(.alwaysOriginal)
        let leftbutton  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(ConversationsVC.showProfile))
        self.navigationItem.leftBarButtonItem = self.leftButton
        //Set Font Size
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 27.0)!]
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        
        OneSignal.registerForPushNotifications()
        
        OneSignal.idsAvailable({(_ userId, _ pushToken) in
            
            print("UserId:\(userId!)")
            
            let playerID = ["playerID": userId!]
            
            let userID = Auth.auth().currentUser?.uid
            
            Database.database().reference().child("users").child(userID!).child("playerID").updateChildValues(playerID, withCompletionBlock: { (errr, _) in
                if errr == nil {
                    print("Your playerID were updated successfully!")
                }
            })
            
        })
   
        if let id = Auth.auth().currentUser?.uid {
            
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                let image = user.profilePic
                let contentSize = CGSize.init(width: 30, height: 30)
                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
                let _  = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
                path.lineWidth = 2
                UIColor.white.setStroke()
                path.stroke()
                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
//                    weakSelf?.leftButton.image = finalImage
                    weakSelf = nil
                }
            })
        }
    }
    

    @IBAction func findConnectOnMap(_ sender: Any) {

    }
    
    //Downloads conversations
    func fetchData() {
        Conversation.showConversations { (conversations) in
            
            self.items = conversations
            self.items.sort{ $0.lastMessage.timestamp > $1.lastMessage.timestamp }
            

            DispatchQueue.main.async {
                self.tableView.reloadData()
                for conversation in self.items {
                    if conversation.lastMessage.isRead == false {
                        self.playSound()
                        break
                    }
                }
            }
        }
    }
    

    
    func downloadConnectorProfile(userID: String){
        
        Database.database().reference().child("users").child(userID).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: Any] {
                
                let connectorIdProfile = [userID: data]
                
                SharingManager.sharedInstance.connectorProfile.append(connectorIdProfile)
                
            }
        })
    }
    
    func downloadUserInfo(userID: String){
        
        //All users location coordinates are updated
        Database.database().reference().child("users").child(userID).child("locationInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? [String: Double] {
                
                let lati = data["latitude"]!
                let longi = data["longitude"]!
                
                var coordinate = CLLocationCoordinate2D()
                coordinate.latitude = lati
                coordinate.longitude = longi
                
                let userIDLocation = [userID: coordinate]
                
                SharingManager.sharedInstance.userLocationArray.append(coordinate)
                SharingManager.sharedInstance.userIDLocation.append(userIDLocation)
                
                print("This is location coordinate \(lati): \(longi)")
                
            }
        })
    }
    
    func realtimeUpdateInfo(){
        
        let timeRemaining = UIApplication.shared.backgroundTimeRemaining
        
        print("BackgroundTimeRemaining => \(timeRemaining)")
        
        if timeRemaining > 3.0 {
            
            SharingManager.sharedInstance.userLocationArray.removeAll()
            SharingManager.sharedInstance.userIDLocation.removeAll()
            
            if self.latitude != nil && self.longitude != nil {
                
                // Send current location and time to server
                self.geoLogLocation(self.latitude, lng: self.longitude)
            }

            Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
                
                let userId = snapshot.key
                
                if (userId == Auth.auth().currentUser?.uid){
                    
                }else{
                    
                    self.downloadUserInfo(userID: userId)
                    
                }
            })
        } else {
            
            if timeRemaining == 0 {
                
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
            backgroundTaskIdentifier2 = UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
                
                // Stops Timer
                self.backgroundTimer.invalidate()
                
                /* Timer initialized everytime an update is received. When timer expires, reverts accuracy to HiGH, thus enabling the delegate to receive new location updates */
                self.backgroundTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ConversationsVC.realtimeUpdateInfo), userInfo: nil, repeats: true)
            })
        }
        
    }
    
    //update location coordinate into firebase database
    func geoLogLocation(_ lat: CLLocationDegrees, lng: CLLocationDegrees){
        
        let location = "\(lat), \(lng)"
        print(location)

        let locationValue = ["latitude": lat, "longitude": lng]
        
        let userID = Auth.auth().currentUser?.uid
        
        if userID == nil{
            
            print("You have already loged out ! ")
            
        }else{
            
            Database.database().reference().child("users").child(userID!).child("locationInfo").updateChildValues(locationValue, withCompletionBlock: { (errr, _) in
                if errr == nil {
                    print("There is no error in this part ! ")
                }else{
                    
                }
            })
            
        }
        
    }
    
    //Shows profile extra view
    func showProfile() {
        let info = ["viewType" : ShowExtraView.profile]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
        self.inputView?.isHidden = true
    }
    
    func sideBarMenu(){
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }
    
    //Shows contacts extra view
    func showContacts() {
        let info = ["viewType" : ShowExtraView.contacts]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showExtraView"), object: nil, userInfo: info)
    }
    
    //Show EmailVerification on the bottom
    func showEmailAlert() {
        User.checkUserVerification {[weak weakSelf = self] (status) in
            status == true ? (weakSelf?.alertBottomConstraint.constant = -40) : (weakSelf?.alertBottomConstraint.constant = 0)
            UIView.animate(withDuration: 0.3) {
                weakSelf?.view.layoutIfNeeded()
                weakSelf = nil
            }
        }
    }
    
    //Shows Chat viewcontroller with given user
    func pushToUserMesssages(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            
            self.selectedUser = user
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    func playSound()  {
        var soundURL: NSURL?
        var soundID:SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "newMessage", ofType: "wav")
        soundURL = NSURL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.selectedUser
        }
        if segue.identifier == "connectprofilesegue" {
            let vc = segue.destination as! ConnectProfileVC
            vc.user = self.selectedUser
        }
    }

    //MARK: Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.items.count == 0 {
            return 1
        } else {
            return self.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return self.view.bounds.height - self.navigationController!.navigationBar.bounds.height
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items.count {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ConversationsTBCell
            cell.clearCellData()
            cell.profilePic.image = self.items[indexPath.row].user.profilePic
            cell.nameLabel.text = self.items[indexPath.row].user.name
            switch self.items[indexPath.row].lastMessage.type {
            case .text:
                let message = self.items[indexPath.row].lastMessage.content as! String
                cell.messageLabel.text = message
            case .location:
                cell.messageLabel.text = "Location"
            default:
                cell.messageLabel.text = "Media"
            }
            let messageDate = Date.init(timeIntervalSince1970: TimeInterval(self.items[indexPath.row].lastMessage.timestamp))
            let dataformatter = DateFormatter.init()
            dataformatter.timeStyle = .short
            let date = dataformatter.string(from: messageDate)
            cell.timeLabel.text = date
            if self.items[indexPath.row].lastMessage.owner == .sender && self.items[indexPath.row].lastMessage.isRead == false {
                cell.nameLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 17.0)
                cell.messageLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 14.0)
                cell.timeLabel.font = UIFont(name:"AvenirNext-DemiBold", size: 13.0)
                cell.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
                cell.messageLabel.textColor = GlobalVariables.purple
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.items.count > 0 {
            self.selectedUser = self.items[indexPath.row].user            
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
       
    //MARK: ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            //Seeking permission of the user to display app notifications
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in })
            UNUserNotificationCenter.current().delegate = self
            
        }
        
        self.findConnectButton.isHidden = true
        
        self.customization()
        self.fetchData()
        
        // Scanning interval = 1 minute
        timeInMinutes = 4

        
        // Authorization for utilization of location services for background process
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            // Location Manager configuration
            self.locationManager.delegate = self
            
            // Location Accuracy, properties
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.allowsBackgroundLocationUpdates = true
            
            locationManager.startUpdatingLocation()
            
        }
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
//        navigationController?.delegate = self
        
        self.realtimeUpdateInfo()
        self.appDelegate.postTimer = Timer.scheduledTimer(timeInterval: self.timeInMinutes, target: self, selector: #selector(ConversationsVC.realtimeUpdateInfo), userInfo: nil, repeats: true)
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            let id = snapshot.key
            
            print("All UIDs are :\(id)")
            let userID = Auth.auth().currentUser?.uid
            
            if(id == userID){
                print("This UID is yours.")
            }else{
                SharingManager.sharedInstance.userCredentialID.append(id)
                SharingManager.sharedInstance.userIDCount.updateValue(0, forKey: id)
                self.downloadConnectorProfile(userID: id)
            }
            
        })

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showEmailAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
}


// MARK: - CLLocationManagerDelegate
extension ConversationsVC:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        
        if self.locationFlag == false{
            
            let locationValue = ["latitude": locValue.latitude, "longitude": locValue.longitude]
            
            let userID = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(userID!).child("locationInfo").updateChildValues(locationValue, withCompletionBlock: { (errr, _) in
                if errr == nil {
                    print("There is no error in this part ! ")
                }
            })
            
            self.locationFlag = true
        }

    }
}




