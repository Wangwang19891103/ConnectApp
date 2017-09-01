//
//  FilterVC.swift
//  QuickChat
//
//  Created by MyCom on 7/11/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class FilterVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var raceTable: UITableView!
    @IBOutlet weak var genderTable: UITableView!
    @IBOutlet weak var weightTable: UITableView!
    @IBOutlet weak var heightTable: UITableView!
    @IBOutlet weak var ageTable: UITableView!
    @IBOutlet weak var eyecolorTable: UITableView!
    @IBOutlet weak var appearanceTable: UITableView!
    @IBOutlet weak var skintoneTable: UITableView!
    @IBOutlet weak var radiusTable: UITableView!
    @IBOutlet weak var religionTable: UITableView!
    @IBOutlet weak var citystateTable: UITableView!
    @IBOutlet weak var musicTable: UITableView!
    @IBOutlet weak var datingTable: UITableView!
    @IBOutlet weak var lifestyleTable: UITableView!
    @IBOutlet weak var careertypeTable: UITableView!
    @IBOutlet weak var lifemottoTable: UITableView!
    
    @IBOutlet weak var raceValue: NoCopyPasteUITextField!
    @IBOutlet weak var genderValue: NoCopyPasteUITextField!
    @IBOutlet weak var weightValue: NoCopyPasteUITextField!
    @IBOutlet weak var heightValue: NoCopyPasteUITextField!
    @IBOutlet weak var ageValue: NoCopyPasteUITextField!
    @IBOutlet weak var eyecolorValue: NoCopyPasteUITextField!
    @IBOutlet weak var appearanceValue: NoCopyPasteUITextField!
    @IBOutlet weak var skintoneValue: NoCopyPasteUITextField!
    @IBOutlet weak var radiusValue: NoCopyPasteUITextField!
    @IBOutlet weak var religionValue: NoCopyPasteUITextField!
    @IBOutlet weak var citystateValue: NoCopyPasteUITextField!
    @IBOutlet weak var musicValue: NoCopyPasteUITextField!
    @IBOutlet weak var datingValue: NoCopyPasteUITextField!
    @IBOutlet weak var lifestyleValue: NoCopyPasteUITextField!
    @IBOutlet weak var careertypeValue: NoCopyPasteUITextField!
    @IBOutlet weak var lifemottoValue: NoCopyPasteUITextField!
    @IBOutlet weak var manualItemValue: NoCopyPasteUITextField!
    
    @IBOutlet weak var raceTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var genderTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var weightTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ageTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eyecolorTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appearanceTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var skintoneTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var radiusTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var religionTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var citystateTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var musicTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var datingTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lifestyleTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var careertypeTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lifemottoTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var inputValueFields: [UITextField]!
    
    @IBOutlet weak var filterCountValue: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var darkView: UIView!
    
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "setting3")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(FilterVC.sideBarMenu))
        return button
    }()
    
    let raceCellReuseIdentifier = "raceCell"
    let genderCellReuseIdentifier = "genderCell"
    let weightCellReuseIdentifier = "weightCell"
    let heightCellReuseIdentifier = "heightCell"
    let ageCellReuseIdentifier = "ageCell"
    let eyecolorCellReuseIdentifier = "eyecolorCell"
    let appearanceCellReuseIdentifier = "appearanceCell"
    let skintoneCellReuseIdentifier = "skintoneCell"
    let radiusCellReuseIdentifier = "radiusCell"
    let religionCellReuseIdentifier = "religionCell"
    let citystateCellReuseIdentifier = "citystateCell"
    let musicCellReuseIdentifier = "musicCell"
    let datingCellReuseIdentifier = "datingCell"
    let lifestyleCellReuseIdentifier = "lifestyleCell"
    let careertypeCellReuseIdentifier = "careertypeCell"
    let lifemottoCellReuseIdentifier = "lifemottoCell"
    let manualItemCellReuseIdentifier = "manualItemCell"

    
    var raceValueComponent = ["Caucasion", "Mongoloid", "Negroid"]
    
    var genderValueComponent = ["male", "female"]
    
    var weightValueComponent = [60, 65, 70, 75, 80, 85, 90, 95, 100, 105]
    
    var heightValueComponent = [160, 165, 170, 175, 180, 185, 190, 195, 200]
    
    var ageValueComponent = [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90]
    
    var eyecolorValueComponent = ["Amber", "Blue", "Brown", "Gray", "Green", "Hazel", "Red", "Violet"]
    
    var appearanceValueComponent = ["athletic", "", "", "", "", "", ""]
    
    var skintoneValueComponent = ["Pale", "Fair", "Light brown", "Caramel", "Bronze", "Mahogany"]
    
    var radiusValueComponent = [100, 500, 1000, 5000, 10000, 50000, 100000, 500000, 1000000]
    
    var religionValueComponent = ["Christianity", "Islam", "Hinduism", "Buddhism"]
    
    var citystateValueComponent = ["Dallas, TEXAS", "Seattle, WASHINGTON", "Miami, FLORIDA", "Los Angeles, CALIFORNIA", "Las Vegas, NEVADA", "Portland, OREGON", "Chicago, ILLINOIS"]
    
    var musicValueComponent = ["Jazz", "Hip-Hop", "R & B_music", "Regional Mexican", "Classical", "Pop", "Rock n Roll", "Blues", "Independent", "Latin", "Dance electric", "Easy listening", "Reggae", "Techno", "Melody", "Folk", "Oldies 70’s, 80’s & 90’s", "Funk disco", "Opera", "Soul", "Gospel", "Religious", "Punk", "World", "Indie rock", "Death Metal"]
    
    var datingValueComponent = ["The Flirt", "The Friend", "Honest & Integrity", "Committed", "Just here", "Openness", "Affectionate", "The giver", "Respect & independence", "Sense a humor", "The Learner", "Adventurer", "The controller", "Hopeless Romantic", "Gothic-lite", "The old-fashion", "The Rebound", "The wine tasters", "The drinkers"]
    
    var lifestyleValueComponent = ["The consumer", "Animal Lover", "Healthy", "The Yogies", "Gym Rat", "Workaholic", "Fast cars", "Nice cars", "Chilled", "Indifferent", "Spontaneous", "Wild n Crazy", "Fun and outgoing", "Slow & steady", "Focused", "The road Tripper", "Peacemaker", "Foodies", "The cooker", "The baker", "The actor", "Adventuresses", "The Golfer", "Movie Goer", "Netflix kicker", "Coffee goer", "Nespresso goer", "Socialite", "The Walker", "The Runner", "The Performers", "Drama club", "Cyclist", "Pedal pushers", "Bikers", "The swimmer", "The Vegan", "The minimalist", "The Churchgoer", "The evangelist", "The missionaries", "Jehovah witness", "The weight watcher", "The student", "The reader"]
    
    
    var careertypeValueComponent = ["The entrepreneur", "The businessman", "The trainer", "The banker", "The teacher", "The engineer", "The student", "The Vet", "The Librarian", "The Doctor", "The Nurse", "The Mechanic", "The painter", "The manager", "The educator", "The chef", "Pre-chef", "The Lawyer", "The Judge", "The Officer", "Drivers", "Truckers", "The scientist", "The chemist", "The dentist", "The architect", "The Pilot", "The stewardesses", "The Cleaners"]
    
    var lifemottoValueComponent = ["Yolo", "Learning every day new things", "Live simply", "The less you have the more have", "Feel the fear and do it anyways", "No risk no reward", "One day at a time", "Your not happy at home; your not happy anywhere else", "Laissez – Let it be", "I am not accepting things I cannot change but changing things I cannot accept"]
    
    var markerPic = [UIImage]()
    
    @IBAction func findConnector(_ sender: Any) {
        
        self.showLoading(state: true)
        
        let filterValues = ["race": self.raceValue.text, "gender": self.genderValue.text, "weight": self.weightValue.text, "height": self.heightValue.text, "age": self.ageValue.text, "eyecolor": self.eyecolorValue.text, "appearance": self.appearanceValue.text, "skintone": self.skintoneValue.text, "radius": self.radiusValue.text, "religion": self.religionValue.text, "citystate": self.citystateValue.text, "music": self.musicValue.text, "dating": self.datingValue.text, "lifestyle": self.lifestyleValue.text, "careertype": self.careertypeValue.text, "lifemotto": self.lifemottoValue.text, "manualitem": self.manualItemValue.text]
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).child("filterValue").updateChildValues(filterValues, withCompletionBlock: { (errr, _) in
            if errr == nil {
                
            }else{
                
            }
        })
        
        createUserIDArray()

    }
    
    func sideBarMenu(){
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }
    
    func createUserIDArray() {
        
        var raceUID = [String]()
        var genderUID = [String]()
        var weightUID = [String]()
        var heightUID = [String]()
        var ageUID = [String]()
        var eyecolorUID = [String]()
        var appearanceUID = [String]()
        var skintoneUID = [String]()
        var radiusUID = [String]()
        var religionUID = [String]()
        var citystateUID = [String]()
        var musicUID = [String]()
        var datingUID = [String]()
        var lifestyleUID = [String]()
        var careertypeUID = [String]()
        var lifemottoUID = [String]()
        var manualItemUID = [String]()

        
        for i in 0 ..< SharingManager.sharedInstance.userCredentialID.count {
            
            Database.database().reference().child("users").child(SharingManager.sharedInstance.userCredentialID[i]).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let profileData = snapshot.value as! [String: String]
                
                if (self.raceValue.text?.range(of: profileData["race"]!) != nil || profileData["race"]?.range(of: self.raceValue.text!) != nil){
                    
                    raceUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.genderValue.text?.range(of: profileData["gender"]!) != nil || profileData["gender"]?.range(of: self.genderValue.text!) != nil){
                    
                    genderUID.append(SharingManager.sharedInstance.userCredentialID[i])
                }
                
                if (self.weightValue.text?.range(of: profileData["weight"]!) != nil || profileData["weight"]?.range(of: self.weightValue.text!) != nil){
                    
                    weightUID.append(SharingManager.sharedInstance.userCredentialID[i])
                }
                
                if (self.heightValue.text?.range(of: profileData["height"]!) != nil || profileData["height"]?.range(of: self.heightValue.text!) != nil){
                    
                    heightUID.append(SharingManager.sharedInstance.userCredentialID[i])
                }
                
                if (self.ageValue.text?.range(of: profileData["age"]!) != nil || profileData["age"]?.range(of: self.ageValue.text!) != nil){
                    
                    ageUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.eyecolorValue.text?.range(of: profileData["eyeColor"]!) != nil || profileData["eyeColor"]?.range(of: self.eyecolorValue.text!) != nil){
                    
                    eyecolorUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.appearanceValue.text?.range(of: profileData["appearance"]!) != nil || profileData["appearance"]?.range(of: self.appearanceValue.text!) != nil){
                    
                    appearanceUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.skintoneValue.text?.range(of: profileData["skinTone"]!) != nil || profileData["skinTone"]?.range(of: self.skintoneValue.text!) != nil){
                    
                    skintoneUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.radiusValue.text?.range(of: profileData["radius"]!) != nil || profileData["radius"]?.range(of: self.radiusValue.text!) != nil){
                    
                    radiusUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.religionValue.text?.range(of: profileData["religion"]!) != nil || profileData["religion"]?.range(of: self.religionValue.text!) != nil){
                    
                    religionUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.citystateValue.text?.range(of: profileData["cityState"]!) != nil || profileData["cityState"]?.range(of: self.citystateValue.text!) != nil){
                    
                    citystateUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.musicValue.text?.range(of: profileData["age"]!) != nil || profileData["age"]?.range(of: self.ageValue.text!) != nil){
                    
                    ageUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }

            })
            
            Database.database().reference().child("users").child(SharingManager.sharedInstance.userCredentialID[i]).child("questionnaire").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let questionnaireData = snapshot.value as! [String: String]
                
                if (self.musicValue.text?.range(of: questionnaireData["Music"]!) != nil || questionnaireData["Music"]?.range(of: self.musicValue.text!) != nil){
                    
                    musicUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.datingValue.text?.range(of: questionnaireData["Dating"]!) != nil || questionnaireData["Dating"]?.range(of: self.datingValue.text!) != nil){
                    
                    datingUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.lifemottoValue.text?.range(of: questionnaireData["Lifemotto"]!) != nil || questionnaireData["Lifemotto"]?.range(of: self.lifemottoValue.text!) != nil){
                    
                    lifemottoUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.lifestyleValue.text?.range(of: questionnaireData["Lifestyle"]!) != nil || questionnaireData["Lifestyle"]?.range(of: self.lifestyleValue.text!) != nil){
                    
                    lifestyleUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.careertypeValue.text?.range(of: questionnaireData["Careertype"]!) != nil || questionnaireData["Careertype"]?.range(of: self.careertypeValue.text!) != nil){
                    
                    careertypeUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if (self.manualItemValue.text?.range(of: questionnaireData["ManualItem"]!) != nil || questionnaireData["ManualItem"]?.range(of: self.manualItemValue.text!) != nil){
                    
                    manualItemUID.append(SharingManager.sharedInstance.userCredentialID[i])
                    
                }
                
                if i == SharingManager.sharedInstance.userCredentialID.count-1{
                    
                    for m1 in 0 ..< raceUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[raceUID[m1]] = SharingManager.sharedInstance.userIDCount[raceUID[m1]]! + 1
                        
                    }
                    
                    for m2 in 0 ..< genderUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[genderUID[m2]] = SharingManager.sharedInstance.userIDCount[genderUID[m2]]! + 1
                        
                    }
                    
                    for m3 in 0 ..< weightUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[weightUID[m3]] = SharingManager.sharedInstance.userIDCount[weightUID[m3]]! + 1
                        
                    }
                    
                    for m4 in 0 ..< heightUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[heightUID[m4]] = SharingManager.sharedInstance.userIDCount[heightUID[m4]]! + 1
                        
                    }
                    
                    for m5 in 0 ..< ageUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[ageUID[m5]] = SharingManager.sharedInstance.userIDCount[ageUID[m5]]! + 1
                        
                    }
                    
                    for m6 in 0 ..< eyecolorUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[eyecolorUID[m6]] = SharingManager.sharedInstance.userIDCount[eyecolorUID[m6]]! + 1
                        
                    }
                    
                    for m7 in 0 ..< appearanceUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[appearanceUID[m7]] = SharingManager.sharedInstance.userIDCount[appearanceUID[m7]]! + 1
                        
                    }
                    
                    for m8 in 0 ..< skintoneUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[skintoneUID[m8]] = SharingManager.sharedInstance.userIDCount[skintoneUID[m8]]! + 1
                        
                    }
                    
                    for m9 in 0 ..< radiusUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[radiusUID[m9]] = SharingManager.sharedInstance.userIDCount[radiusUID[m9]]! + 1
                        
                    }
                    
                    for m10 in 0 ..< religionUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[religionUID[m10]] = SharingManager.sharedInstance.userIDCount[religionUID[m10]]! + 1
                        
                    }
                    
                    for m11 in 0 ..< citystateUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[citystateUID[m11]] = SharingManager.sharedInstance.userIDCount[citystateUID[m11]]! + 1
                        
                    }
                    
                    for m12 in 0 ..< musicUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[musicUID[m12]] = SharingManager.sharedInstance.userIDCount[musicUID[m12]]! + 1
                        
                    }
                    
                    for m13 in 0 ..< datingUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[datingUID[m13]] = SharingManager.sharedInstance.userIDCount[datingUID[m13]]! + 1
                        
                    }
                    
                    for m14 in 0 ..< lifestyleUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[lifestyleUID[m14]] = SharingManager.sharedInstance.userIDCount[lifestyleUID[m14]]! + 1
                        
                    }
                    
                    for m15 in 0 ..< careertypeUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[careertypeUID[m15]] = SharingManager.sharedInstance.userIDCount[careertypeUID[m15]]! + 1
                        
                    }
                    
                    for m16 in 0 ..< lifemottoUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[lifemottoUID[m16]] = SharingManager.sharedInstance.userIDCount[lifemottoUID[m16]]! + 1
                        
                    }
                    
                    for m17 in 0 ..< manualItemUID.count{
                        
                        SharingManager.sharedInstance.userIDCount[manualItemUID[m17]] = SharingManager.sharedInstance.userIDCount[manualItemUID[m17]]! + 1
                        
                    }

                    for k in 0 ..< SharingManager.sharedInstance.userIDCount.count {
                        
                        if( SharingManager.sharedInstance.userIDCount[SharingManager.sharedInstance.userCredentialID[k]]! >= (self.filterCountValue.text! as NSString).integerValue ){
                            
                            SharingManager.sharedInstance.filteredUID.append(SharingManager.sharedInstance.userCredentialID[k])
                            
                        }
                        
                    }
                    
                    for j in 0 ..< SharingManager.sharedInstance.filteredUID.count {
                        
                        Database.database().reference().child("users").child(SharingManager.sharedInstance.filteredUID[j]).child("locationInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let data = snapshot.value as? [String: Double] {
                                
                                let lati = data["latitude"]!
                                let longi = data["longitude"]!

                                
                                var coordinate = CLLocationCoordinate2D()
                                coordinate.latitude = lati
                                coordinate.longitude = longi
                                
                                let userIdMarkerDic = [SharingManager.sharedInstance.filteredUID[j]: coordinate]
                                
                                SharingManager.sharedInstance.filteredUserLocationArray.append(coordinate)
                                SharingManager.sharedInstance.userIDMarker.append(userIdMarkerDic)                                
                                
                                if j == SharingManager.sharedInstance.filteredUID.count-1{
                                    
                                    print("This is filteredUID count : \(SharingManager.sharedInstance.filteredUID.count)")
                                    print("This is filteredUserLocationArray count : \(SharingManager.sharedInstance.filteredUserLocationArray.count)")
                                    
                                    self.showLoading(state: false)
                                    
                                    self.performSegue(withIdentifier: "mapview", sender: nil)
                                    
                                }
                                
                            }
                        })
                        
                    }
                    
                    
                }
            })
        }
        
    }
    
    func showLoading(state: Bool)  {
        if state {
            self.darkView.isHidden = false
            self.spinner.startAnimating()
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0.5
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0
            }, completion: { _ in
                self.spinner.stopAnimating()
                self.darkView.isHidden = true
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapview" {
            
            _ = segue.destination as! MapViewController

        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        SharingManager.sharedInstance.filteredUID.removeAll()
        SharingManager.sharedInstance.userIDMarker.removeAll()
        SharingManager.sharedInstance.filteredUserLocationArray.removeAll()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.darkView.alpha = 0
        
        self.filterCountValue.isHidden = true

        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem = self.leftButton
        
        self.raceTable.register(UITableViewCell.self, forCellReuseIdentifier: raceCellReuseIdentifier)
        
        raceTable.delegate = self
        raceTable.dataSource = self
        raceTable.isHidden = true
        raceValue.delegate = self
        
        raceValue.addTarget(self, action: #selector(raceTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.genderTable.register(UITableViewCell.self, forCellReuseIdentifier: genderCellReuseIdentifier)
        
        genderTable.delegate = self
        genderTable.dataSource = self
        genderTable.isHidden = true
        genderValue.delegate = self
        
        genderValue.addTarget(self, action: #selector(genderTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.weightTable.register(UITableViewCell.self, forCellReuseIdentifier: weightCellReuseIdentifier)
        
        weightTable.delegate = self
        weightTable.dataSource = self
        weightTable.isHidden = true
        weightValue.delegate = self
        
        weightValue.addTarget(self, action: #selector(weightTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.heightTable.register(UITableViewCell.self, forCellReuseIdentifier: heightCellReuseIdentifier)
        
        heightTable.delegate = self
        heightTable.dataSource = self
        heightTable.isHidden = true
        heightValue.delegate = self
        
        heightValue.addTarget(self, action: #selector(heightTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.ageTable.register(UITableViewCell.self, forCellReuseIdentifier: ageCellReuseIdentifier)
        
        ageTable.delegate = self
        ageTable.dataSource = self
        ageTable.isHidden = true
        ageValue.delegate = self
        
        ageValue.addTarget(self, action: #selector(ageTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.eyecolorTable.register(UITableViewCell.self, forCellReuseIdentifier: eyecolorCellReuseIdentifier)
        
        eyecolorTable.delegate = self
        eyecolorTable.dataSource = self
        eyecolorTable.isHidden = true
        eyecolorValue.delegate = self
        
        eyecolorValue.addTarget(self, action: #selector(eyecolorTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.appearanceTable.register(UITableViewCell.self, forCellReuseIdentifier: appearanceCellReuseIdentifier)
        
        appearanceTable.delegate = self
        appearanceTable.dataSource = self
        appearanceTable.isHidden = true
        appearanceValue.delegate = self
        
        appearanceValue.addTarget(self, action: #selector(appearanceTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.skintoneTable.register(UITableViewCell.self, forCellReuseIdentifier: skintoneCellReuseIdentifier)
        
        skintoneTable.delegate = self
        skintoneTable.dataSource = self
        skintoneTable.isHidden = true
        skintoneValue.delegate = self
        
        skintoneValue.addTarget(self, action: #selector(skintoneTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.radiusTable.register(UITableViewCell.self, forCellReuseIdentifier: radiusCellReuseIdentifier)
        
        radiusTable.delegate = self
        radiusTable.dataSource = self
        radiusTable.isHidden = true
        radiusValue.delegate = self
        
        radiusValue.addTarget(self, action: #selector(radiusTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.religionTable.register(UITableViewCell.self, forCellReuseIdentifier: religionCellReuseIdentifier)
        
        religionTable.delegate = self
        religionTable.dataSource = self
        religionTable.isHidden = true
        religionValue.delegate = self
        
        religionValue.addTarget(self, action: #selector(religionTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.citystateTable.register(UITableViewCell.self, forCellReuseIdentifier: citystateCellReuseIdentifier)
        
        citystateTable.delegate = self
        citystateTable.dataSource = self
        citystateTable.isHidden = true
        citystateValue.delegate = self
        
        citystateValue.addTarget(self, action: #selector(citystateTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.musicTable.register(UITableViewCell.self, forCellReuseIdentifier: musicCellReuseIdentifier)
        
        musicTable.delegate = self
        musicTable.dataSource = self
        musicTable.isHidden = true
        musicValue.delegate = self
        
        musicValue.addTarget(self, action: #selector(musicTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.datingTable.register(UITableViewCell.self, forCellReuseIdentifier: datingCellReuseIdentifier)
        
        datingTable.delegate = self
        datingTable.dataSource = self
        datingTable.isHidden = true
        datingValue.delegate = self
        
        datingValue.addTarget(self, action: #selector(datingTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.lifestyleTable.register(UITableViewCell.self, forCellReuseIdentifier: lifestyleCellReuseIdentifier)
        
        lifestyleTable.delegate = self
        lifestyleTable.dataSource = self
        lifestyleTable.isHidden = true
        lifestyleValue.delegate = self
        
        lifestyleValue.addTarget(self, action: #selector(lifestyleTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.careertypeTable.register(UITableViewCell.self, forCellReuseIdentifier: careertypeCellReuseIdentifier)
        
        careertypeTable.delegate = self
        careertypeTable.dataSource = self
        careertypeTable.isHidden = true
        careertypeValue.delegate = self
        
        careertypeValue.addTarget(self, action: #selector(careertypeTextFieldActive), for: UIControlEvents.touchDown)
        
        
        self.lifemottoTable.register(UITableViewCell.self, forCellReuseIdentifier: lifemottoCellReuseIdentifier)
        
        lifemottoTable.delegate = self
        lifemottoTable.dataSource = self
        lifemottoTable.isHidden = true
        lifemottoValue.delegate = self
        
        lifemottoValue.addTarget(self, action: #selector(lifemottoTextFieldActive), for: UIControlEvents.touchDown)
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).child("filterValue").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                
                self.raceValue.text = data["race"]!
                self.genderValue.text = data["gender"]!
                self.weightValue.text = data["weight"]!
                self.heightValue.text = data["height"]!
                self.ageValue.text = data["age"]!
                self.eyecolorValue.text = data["eyecolor"]!
                self.appearanceValue.text = data["appearance"]!
                self.skintoneValue.text = data["skintone"]!
                self.radiusValue.text = data["radius"]!
                self.religionValue.text = data["religion"]!
                self.citystateValue.text = data["citystate"]!
                self.musicValue.text = data["music"]!
                self.datingValue.text = data["dating"]!
                self.lifestyleValue.text = data["lifestyle"]!
                self.careertypeValue.text = data["careertype"]!
                self.lifemottoValue.text = data["lifemotto"]!
                self.manualItemValue.text = data["manualitem"]!
                
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        raceTableHeightConstraint.constant = 200
        genderTableHeightConstraint.constant = 100
        weightTableHeightConstraint.constant = 200
        heightTableHeightConstraint.constant = 200
        ageTableHeightConstraint.constant = 200
        eyecolorTableHeightConstraint.constant = 200
        appearanceTableHeightConstraint.constant = 200
        skintoneTableHeightConstraint.constant = 200
        radiusTableHeightConstraint.constant = 200
        religionTableHeightConstraint.constant = 100
        citystateTableHeightConstraint.constant = 200
        musicTableHeightConstraint.constant = 200
        datingTableHeightConstraint.constant = 200
        lifestyleTableHeightConstraint.constant = 200
        careertypeTableHeightConstraint.constant = 200
        lifemottoTableHeightConstraint.constant = 200
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        
        if (touch.view !== raceTable){
            
            raceValue.endEditing(true)
            raceTable.isHidden = true
            
        }
        if (touch.view !== genderTable){
            
            genderValue.endEditing(true)
            genderTable.isHidden = true
            
        }
        if (touch.view !== weightTable){
            
            weightValue.endEditing(true)
            weightTable.isHidden = true
            
        }
        if (touch.view !== heightTable){
            
            heightValue.endEditing(true)
            heightTable.isHidden = true
            
        }
        if (touch.view !== ageTable){
            
            ageValue.endEditing(true)
            ageTable.isHidden = true
            
        }
        if (touch.view !== eyecolorTable){
            
            eyecolorValue.endEditing(true)
            eyecolorTable.isHidden = true
            
        }
        if (touch.view !== appearanceTable){
            
            appearanceValue.endEditing(true)
            appearanceTable.isHidden = true
            
        }
        if (touch.view !== skintoneTable){
            
            skintoneValue.endEditing(true)
            skintoneTable.isHidden = true
            
        }
        if (touch.view !== radiusTable){
            
            radiusValue.endEditing(true)
            radiusTable.isHidden = true
            
        }
        if (touch.view !== religionTable){
            
            religionValue.endEditing(true)
            religionTable.isHidden = true
            
        }
        if (touch.view !== citystateTable){
            
            citystateValue.endEditing(true)
            citystateTable.isHidden = true
            
        }
        if (touch.view !== musicTable){
            
            musicValue.endEditing(true)
            musicTable.isHidden = true
            
        }
        if (touch.view !== lifemottoTable){
            
            lifemottoValue.endEditing(true)
            lifemottoTable.isHidden = true
            
        }
        if (touch.view !== datingTable){
            
            datingValue.endEditing(true)
            datingTable.isHidden = true
            
        }
        if (touch.view !== lifestyleTable){
            
            lifestyleValue.endEditing(true)
            lifestyleTable.isHidden = true
        }
        if (touch.view !== careertypeTable){
            
            careertypeValue.endEditing(true)
            careertypeTable.isHidden = true
            
        }
        
    }

    
    func raceTextFieldActive(){
        raceTable.isHidden = !musicTable.isHidden
    }
    
    func genderTextFieldActive(){
        genderTable.isHidden = !genderTable.isHidden
    }
    
    func weightTextFieldActive(){
        weightTable.isHidden = !weightTable.isHidden
    }
    
    func heightTextFieldActive(){
        heightTable.isHidden = !heightTable.isHidden
    }
    
    func ageTextFieldActive(){
        ageTable.isHidden = !ageTable.isHidden
    }
    
    func eyecolorTextFieldActive(){
        eyecolorTable.isHidden = !eyecolorTable.isHidden
    }
    
    func appearanceTextFieldActive(){
        appearanceTable.isHidden = !appearanceTable.isHidden
    }
    
    func skintoneTextFieldActive(){
        skintoneTable.isHidden = !skintoneTable.isHidden
    }
    
    func radiusTextFieldActive(){
        radiusTable.isHidden = !radiusTable.isHidden
    }
    
    func religionTextFieldActive(){
        religionTable.isHidden = !religionTable.isHidden
    }
    
    func citystateTextFieldActive(){
        citystateTable.isHidden = !citystateTable.isHidden
    }
    
    func musicTextFieldActive(){
        musicTable.isHidden = !musicTable.isHidden
    }
    
    func datingTextFieldActive(){
        datingTable.isHidden = !datingTable.isHidden
    }
    
    func lifestyleTextFieldActive(){
        lifestyleTable.isHidden = !lifestyleTable.isHidden
    }
    
    func careertypeTextFieldActive(){
        careertypeTable.isHidden = !careertypeTable.isHidden
    }
    
    func lifemottoTextFieldActive(){
        lifemottoTable.isHidden = !lifemottoTable.isHidden
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Your app can do something when textfield finishes editing
        print("The textfield ended editing. Do something based on app requirements.")
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("The textfield  editing. Do something based on app requirements.")

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(tableView == raceTable){
            return raceValueComponent.count
        }else if(tableView == genderTable){
            return genderValueComponent.count
        }else if(tableView == weightTable){
            return weightValueComponent.count
        }else if(tableView == heightTable){
            return heightValueComponent.count
        }else if(tableView == ageTable){
            return ageValueComponent.count
        }else if(tableView == eyecolorTable){
            return eyecolorValueComponent.count
        }else if(tableView == appearanceTable){
            return appearanceValueComponent.count
        }else if(tableView == skintoneTable){
            return skintoneValueComponent.count
        }else if(tableView == radiusTable){
            return radiusValueComponent.count
        }else if(tableView == religionTable){
            return religionValueComponent.count
        }else if(tableView == citystateTable){
            return citystateValueComponent.count
        }else if(tableView == musicTable){
            return musicValueComponent.count
        }else if(tableView == lifemottoTable){
            return lifemottoValueComponent.count
        }else if(tableView == datingTable){
            return datingValueComponent.count
        }else if(tableView == lifestyleTable){
            return lifestyleValueComponent.count
        }else if(tableView == careertypeTable){
            return careertypeValueComponent.count
        }else{
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(tableView == raceTable){
            
            raceValue.text = raceValueComponent[indexPath.row]
            tableView.isHidden = true
            raceValue.endEditing(true)
            
        }else if(tableView == genderTable){
            
            genderValue.text = genderValueComponent[indexPath.row]
            tableView.isHidden = true
            genderValue.endEditing(true)
            
        }else if(tableView == weightTable){
            
            weightValue.text = String(weightValueComponent[indexPath.row])
            tableView.isHidden = true
            weightValue.endEditing(true)
            
        }else if(tableView == heightTable){
            
            heightValue.text = String(heightValueComponent[indexPath.row])
            tableView.isHidden = true
            heightValue.endEditing(true)
            
        }else if(tableView == ageTable){
            
            ageValue.text = String(ageValueComponent[indexPath.row])
            tableView.isHidden = true
            ageValue.endEditing(true)
            
        }else if(tableView == eyecolorTable){
            
            eyecolorValue.text = eyecolorValueComponent[indexPath.row]
            tableView.isHidden = true
            eyecolorValue.endEditing(true)
            
        }else if(tableView == appearanceTable){
            
            appearanceValue.text = appearanceValueComponent[indexPath.row]
            tableView.isHidden = true
            appearanceValue.endEditing(true)
            
        }else if(tableView == skintoneTable){
            
            skintoneValue.text = skintoneValueComponent[indexPath.row]
            tableView.isHidden = true
            skintoneValue.endEditing(true)
            
        }else if(tableView == radiusTable){
            
            radiusValue.text = String(radiusValueComponent[indexPath.row])
            tableView.isHidden = true
            radiusValue.endEditing(true)
            
        }else if(tableView == religionTable){
            
            religionValue.text = religionValueComponent[indexPath.row]
            tableView.isHidden = true
            religionValue.endEditing(true)
            
        }else if(tableView == citystateTable){
            
            citystateValue.text = citystateValueComponent[indexPath.row]
            tableView.isHidden = true
            citystateValue.endEditing(true)
            
        }else if(tableView == musicTable){
            
            musicValue.text = musicValueComponent[indexPath.row]
            tableView.isHidden = true
            musicValue.endEditing(true)
            
        }else if(tableView == lifemottoTable){
            
            lifemottoValue.text = lifemottoValueComponent[indexPath.row]
            tableView.isHidden = true
            lifemottoValue.endEditing(true)
            
        }else if(tableView == datingTable){
            
            datingValue.text = datingValueComponent[indexPath.row]
            tableView.isHidden = true
            datingValue.endEditing(true)
            
        }else if(tableView == lifestyleTable){
            
            lifestyleValue.text = lifestyleValueComponent[indexPath.row]
            tableView.isHidden = true
            lifestyleValue.endEditing(true)
            
        }else if(tableView == careertypeTable){
            
            careertypeValue.text = careertypeValueComponent[indexPath.row]
            tableView.isHidden = true
            careertypeValue.endEditing(true)
            
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(tableView == raceTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: raceCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = raceValueComponent[indexPath.row]
            cell.textLabel?.font = raceValue.font
            
            return cell
            
        }else if(tableView == genderTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: genderCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = genderValueComponent[indexPath.row]
            cell.textLabel?.font = genderValue.font
            
            return cell
            
        }else if(tableView == weightTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: weightCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = String(weightValueComponent[indexPath.row])
            cell.textLabel?.font = weightValue.font
            
            return cell
            
        }else if(tableView == heightTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: heightCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = String(heightValueComponent[indexPath.row])
            cell.textLabel?.font = heightValue.font
            
            return cell
            
        }else if(tableView == ageTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ageCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = String(ageValueComponent[indexPath.row])
            cell.textLabel?.font = ageValue.font
            
            return cell
            
        }else if(tableView == eyecolorTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: eyecolorCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = eyecolorValueComponent[indexPath.row]
            cell.textLabel?.font = eyecolorValue.font
            
            return cell
            
        }else if(tableView == appearanceTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: appearanceCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = appearanceValueComponent[indexPath.row]
            cell.textLabel?.font = appearanceValue.font
            
            return cell
            
        }else if(tableView == skintoneTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: skintoneCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = skintoneValueComponent[indexPath.row]
            cell.textLabel?.font = skintoneValue.font
            
            return cell
            
        }else if(tableView == radiusTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: radiusCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = String(radiusValueComponent[indexPath.row])
            cell.textLabel?.font = radiusValue.font
            
            return cell
            
        }else if(tableView == religionTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: religionCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = religionValueComponent[indexPath.row]
            cell.textLabel?.font = religionValue.font
            
            return cell
            
        }else if(tableView == citystateTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: citystateCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = citystateValueComponent[indexPath.row]
            cell.textLabel?.font = citystateValue.font
            
            return cell
            
        }else if(tableView == musicTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: musicCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = musicValueComponent[indexPath.row]
            cell.textLabel?.font = musicValue.font
            
            return cell
        }else if(tableView == lifemottoTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: lifemottoCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = lifemottoValueComponent[indexPath.row]
            cell.textLabel?.font = lifemottoValue.font
            
            return cell
        }else if(tableView == datingTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: datingCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = datingValueComponent[indexPath.row]
            cell.textLabel?.font = datingValue.font
            
            return cell
            
        }else if(tableView == lifestyleTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: lifestyleCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = lifestyleValueComponent[indexPath.row]
            cell.textLabel?.font = lifestyleValue.font
            
            return cell
            
        }else if(tableView == careertypeTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: careertypeCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = careertypeValueComponent[indexPath.row]
            cell.textLabel?.font = careertypeValue.font
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: manualItemCellReuseIdentifier, for: indexPath as IndexPath)
            
            return cell
        }

        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
 
    
    
}
