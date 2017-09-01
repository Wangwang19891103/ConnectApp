//
//  MapViewController.swift
//  QuickChat
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Firebase
import PubNub

class MapViewController: UIViewController, GMSMapViewDelegate{

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var connectorName: UILabel!
    @IBOutlet weak var ageValue: UILabel!
    @IBOutlet weak var appearanceValue: UILabel!
    @IBOutlet weak var genderValue: UILabel!
    @IBOutlet weak var heightValue: UILabel!
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var eyeColorValue: UILabel!
    @IBOutlet weak var skintoneValue: UILabel!
    @IBOutlet weak var citystateValue: UILabel!
    @IBOutlet weak var raceValue: UILabel!
    @IBOutlet weak var radiusValue: UILabel!
    @IBOutlet weak var religionValue: UILabel!
    
    let darkView = UIView.init()
    
    var topAnchorContraint = NSLayoutConstraint()
    
    var locationManager = CLLocationManager()
    
    var locationCoordinate = CLLocationCoordinate2D()
    
    var locationMarker: GMSMarker!
    
    var user: User?
    
    var markerPic = [UIImage]()
    
    var appDelegateMarker: AppDelegate!

    var timeInMinutes: TimeInterval!
    
    var backgroundTimer: Timer!
    
    var userIDPic = [Dictionary<String, Any>]()
    
    // BackgroundTaskIdentifier for background update location
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    var backgroundTaskIdentifier2: UIBackgroundTaskIdentifier!
    
    
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "setting3")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(MapViewController.sideBarMenu))
        return button
    }()
    
    func customization(){
        
        //DarkView customization
        self.view.addSubview(self.darkView)
        self.darkView.backgroundColor = UIColor.black
        self.darkView.alpha = 0
        self.darkView.translatesAutoresizingMaskIntoConstraints = false
        self.darkView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.darkView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.darkView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.darkView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.darkView.isHidden = true
        
        //ContainerView customization
        let extraViewsContainer = UIView.init()
        extraViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(extraViewsContainer)
        self.topAnchorContraint = NSLayoutConstraint.init(item: extraViewsContainer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.topAnchorContraint.isActive = true
        extraViewsContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        extraViewsContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        extraViewsContainer.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        extraViewsContainer.backgroundColor = UIColor.clear
        
        
        //ProfileView Customization
        extraViewsContainer.addSubview(self.profileView)
//        self.profileView.translatesAutoresizingMaskIntoConstraints = false
        self.profileView.translatesAutoresizingMaskIntoConstraints = true
        self.profileView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width * 0.9)).isActive = false//true
        let profileViewAspectRatio = NSLayoutConstraint.init(item: self.profileView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self.profileView, attribute: .height, multiplier: 1.0, constant: 1)
        profileViewAspectRatio.isActive = true
        self.profileView.centerXAnchor.constraint(equalTo: extraViewsContainer.centerXAnchor).isActive = true
        self.profileView.centerYAnchor.constraint(equalTo: extraViewsContainer.centerYAnchor).isActive = true
        self.profileView.layer.cornerRadius = 10
        self.profileView.clipsToBounds = true
        self.profileView.isHidden = true
        self.view.layoutIfNeeded()

        
    }
    
    //Hide extra views
    func dismissExtraViews(){
        
        self.topAnchorContraint.constant = 1000
        UIView.animate(withDuration:  0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            self.darkView.alpha = 0
            self.view.transform = CGAffineTransform.identity
        }, completion:  { (true) in
            self.darkView.isHidden = true
            self.profileView.isHidden = true
            let vc = MapViewController()
            vc.inputAccessoryView?.isHidden = false
        })
        
    }
    
    func showExtraViews(){
        
        let transform = CGAffineTransform.init(scaleX: 0.94, y: 0.94)
        self.topAnchorContraint.constant = 0
        self.darkView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.darkView.alpha = 0.8
            self.view.transform = transform
            
        })
        
        self.inputView?.isHidden = true
        self.profileView.isHidden = false
        
        
        
    }

    func sideBarMenu(){
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }
    
    // Set Marker
    func setuplocationMarker(_ coordinate: CLLocationCoordinate2D, index: Int, userImage: UIImage) {

        let markerImage = resizeImage(image: userImage, newWidth: 100)
        let markerView = UIImageView(image: markerImage)
        markerView.frame.size.width = 50.0
        markerView.frame.size.height = 50.0
        markerView.layer.cornerRadius = markerView.frame.size.width/2
        markerView.layer.borderWidth = 2.0
        markerView.clipsToBounds = true
        markerView.layer.borderColor = GlobalVariables.blue.cgColor

        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        locationMarker.iconView = markerView



        
//        locationMarker.title = "marker"
        
        print("coordinates are \(coordinate.latitude) \(coordinate.longitude)")

        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func realtimeUpdateInfo(){
        
        let timeRemaining = UIApplication.shared.backgroundTimeRemaining
        
        print(" user count is => \(SharingManager.sharedInstance.userLocationArray.count)")
        print(" userID count is => \(SharingManager.sharedInstance.userCredentialID.count)")
        
        if timeRemaining > 3.0 {
            
            mapView.clear()
            
            var index = 0
            var userImage = UIImage()
            var userLocation = CLLocationCoordinate2D()
            
            for i in 0 ..< SharingManager.sharedInstance.filteredUID.count{
                
                //Accroding to userID, set user image.
                for k in 0 ..< self.userIDPic.count{
                    
                    if self.userIDPic[k][SharingManager.sharedInstance.filteredUID[i]] != nil{
                        userImage = self.userIDPic[k][SharingManager.sharedInstance.filteredUID[i]] as! UIImage
                    }else{
                        
                    }
                }
                
                for j in 0 ..< SharingManager.sharedInstance.userIDLocation.count{
                    
                    if SharingManager.sharedInstance.userIDLocation[j][SharingManager.sharedInstance.filteredUID[i]] != nil{

                        userLocation = SharingManager.sharedInstance.userIDLocation[j][SharingManager.sharedInstance.filteredUID[i]] as! CLLocationCoordinate2D
                        
                    }else{
                        
                    }
                }
                
                self.setuplocationMarker(userLocation, index: index, userImage: userImage)
                
                index += 1
            }
            
        } else {
            
            if timeRemaining == 0 {
                
               UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
            
            backgroundTaskIdentifier2 = UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
                
                // Stops Timer
                self.backgroundTimer.invalidate()
                
                /* Timer initialized everytime an update is received. When timer expires, reverts accuracy to HiGH, thus enabling the delegate to receive new location updates */
                self.backgroundTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(MapViewController.realtimeUpdateInfo), userInfo: nil, repeats: true)
            })

        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.leftButton
        
        self.customization()
        
        self.profileView.isHidden = true
        
        timeInMinutes = 3
        
        mapView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        
        appDelegateMarker = UIApplication.shared.delegate as! AppDelegate
        
        self.appDelegateMarker.postTimer = Timer.scheduledTimer(timeInterval: self.timeInMinutes, target: self, selector: #selector(MapViewController.realtimeUpdateInfo), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.profileView.isHidden = true
        
        mapView.clear()
        
        // Start the update of user's Location
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.indoorPicker = true

        
        
        locationManager.delegate = self
        
        // Request permission to use Location service
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if self.locationManager.location?.coordinate != nil{
            
            self.locationCoordinate = (self.locationManager.location?.coordinate)!
            
            self.mapView.camera = GMSCameraPosition(target: locationCoordinate, zoom: 5, bearing: 0, viewingAngle: 0)
            
            // Set compass of map view
            mapView.settings.compassButton = true
            let mapInsets = UIEdgeInsets(top: 40.0, left: 0.0, bottom: 0.0, right: 0.0)
            mapView.padding = mapInsets
            
        }
        
        var index = 0
        
        for i in 0 ..< SharingManager.sharedInstance.filteredUserLocationArray.count {
            
            User.info(forUserID: SharingManager.sharedInstance.filteredUID[i], completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    
                    weakSelf?.markerPic.append(user.profilePic)
                    
                    self.setuplocationMarker(SharingManager.sharedInstance.filteredUserLocationArray[i], index: index, userImage: user.profilePic)
                    
                    let userIDPic = [SharingManager.sharedInstance.filteredUID[i]: user.profilePic]
                    
                    self.userIDPic.append(userIDPic)
                    
                    index += 1
                    weakSelf = nil
                }
            })
 
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapchat" {
            let vc = segue.destination as! ChatVC
            vc.currentUser = self.user
        }
        
        if segue.identifier == "connectprofileview" {
            let vc = segue.destination as! ConnectProfileVC
            vc.user = self.user
        }
    }
    
    func pushToUserMesssages(notification: NSNotification) {
        
//        if let user = notification.userInfo?["user"] as? User {
//            self.user = user
//            self.performSegue(withIdentifier: "mapchat", sender: self)
//        }
        
        if let user = notification.userInfo?["user"] as? User {
            self.user = user
            self.performSegue(withIdentifier: "connectprofileview", sender: self)
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool{
        
//        self.view.addSubview(profileView)
        
        var markerID = String()

        var locationTemp = CLLocationCoordinate2D()
        
        var connectorProfileInfo = [String: Any]()
        
        for i in 0 ..< SharingManager.sharedInstance.filteredUID.count {
            
            for j in 0 ..< SharingManager.sharedInstance.userIDLocation.count{
                
                if SharingManager.sharedInstance.userIDLocation[j][SharingManager.sharedInstance.filteredUID[i]] != nil{
                    
                    locationTemp = SharingManager.sharedInstance.userIDLocation[j][SharingManager.sharedInstance.filteredUID[i]] as! CLLocationCoordinate2D
                    
                    if marker.position.latitude == locationTemp.latitude && marker.position.longitude == locationTemp.longitude{
                        
                        markerID = SharingManager.sharedInstance.filteredUID[i]
                        
                        //display markerID user profile
                        for k in 0 ..< SharingManager.sharedInstance.connectorProfile.count{
                            
                            if SharingManager.sharedInstance.connectorProfile[k][markerID] != nil{
                                
                                connectorProfileInfo = SharingManager.sharedInstance.connectorProfile[k][markerID] as! [String : Any]
                                
                            }else{
                                print("You can not find marker connector profile.")
                            }
                        }
                        
                        print("\(markerID)")
                        
                        User.info(forUserID: markerID, completion: {[weak weakSelf = self] (user) in
                            DispatchQueue.main.async {
                                
                                weakSelf?.user = user
                                self.performSegue(withIdentifier: "connectprofileview", sender: self)
                                
                                weakSelf = nil
                            }
                        })
                        
                    }else{
                        print("Sorry but you can not get markerID.")
                    }
                    
                }else{
                    print("Sorry but you can not get marker location coordinate.")
                }
            }
        }
        
        return true
        
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.first != nil {
            
            // Create marker and set Location
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            locationManager.stopUpdatingLocation()
        }
    }
    

}


