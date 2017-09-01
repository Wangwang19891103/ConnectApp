//
//  ProfileVC.swift
//  QuickChat
//
//  Created by MyCom on 6/30/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase
import Photos
import GlidingCollection

class ProfileVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileEdit: UIView!
    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var saveButton: RoundedButton!
    @IBOutlet weak var raceView: UIView!
    @IBOutlet weak var raceValue: UITextField!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderValue: UITextField!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightValue: UITextField!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightValue: UITextField!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageValue: UITextField!
    @IBOutlet weak var eyeColorView: UIView!
    @IBOutlet weak var eyeColorValue: UITextField!
    @IBOutlet weak var appearanceView: UIView!
    @IBOutlet weak var appearanceValue: UITextField!
    @IBOutlet weak var skinToneView: UIView!
    @IBOutlet weak var skinToneValue: UITextField!
    @IBOutlet weak var radiusView: UIView!
    @IBOutlet weak var radiusValue: UITextField!
    @IBOutlet weak var religionView: UIView!
    @IBOutlet weak var religionValue: UITextField!

    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var cityStateValue: NoCopyPasteUITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var imageScrollView: UICollectionView!
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var citystateTable: UITableView!
    @IBOutlet weak var citystateTableHeightConstraint: NSLayoutConstraint!
    
    
    let citystateCellReuseIdentifier = "citystateCell111"
    
    var citystateValueComponent = ["New York", "San Jose", "City"]
    
    
    @IBOutlet var inputValueFields: [UITextField]!
    @IBOutlet weak var bioValue: UITextView!
    
    var userName = String()
    
    var emailAddress = String()
    
    let profileImagePicker = UIImagePickerController()
    
    var profilePhotoFlag = Bool()
    
    var profileImageFlag = Bool()
    
    var favoriteImageString = [String]()
    
    var favoriteImageArray = [UIImage]()
    
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "setting3")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(ProfileVC.sideBarMenu))
        return button
    }()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.darkView.alpha = 0
        
        self.bioValue.layer.cornerRadius = 10
        
        favoriteImageString.removeAll()
        favoriteImageArray.removeAll()
        
        self.citystateTable.register(UITableViewCell.self, forCellReuseIdentifier: citystateCellReuseIdentifier)
        
        citystateTable.delegate = self
        citystateTable.dataSource = self
        citystateTable.isHidden = true
        cityStateValue.delegate = self
        
        cityStateValue.addTarget(self, action: #selector(citystateTextFieldActive), for: UIControlEvents.touchDown)
        
        self.navigationItem.leftBarButtonItem = self.leftButton
        
        
        self.profileEdit.layer.cornerRadius = 8
        self.profileImagePicker.delegate = self
        self.profileImage.layer.borderColor = GlobalVariables.blue.cgColor
        self.profileImage.layer.borderWidth = 2
        
        self.fetchUserProfile()
        self.fetchUserInfo()


        
        imageScrollView.delegate = self
        imageScrollView.dataSource = self
        
        self.imageScrollView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let userID = Auth.auth().currentUser?.uid
        
        profilePhotoFlag = false
        profileImageFlag = false
        
        Database.database().reference().child("users").child(userID!).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                
                self.userName = data["name"]!
                
                self.emailAddress = data["email"]!
                
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        citystateTableHeightConstraint.constant = 150
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch = touches.first!
        
        if(touch.view !== citystateTable){
            cityStateValue.endEditing(true)
            citystateTable.isHidden = true
        }
    }
    
    func sideBarMenu(){
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
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
    
    func citystateTextFieldActive(){
        citystateTable.isHidden = !citystateTable.isHidden
    }
  
    @IBAction func catchFavoriteImages(_ sender: Any) {
        
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWithImages(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWithImages(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    @IBAction func profileSave(_ sender: Any) {
        
         self.showLoading(state: true)
        
        for item in self.inputValueFields {
            item.resignFirstResponder()
        }
        
        let values = ["race": self.raceValue.text, "gender": self.genderValue.text, "weight": self.weightValue.text, "height": self.heightValue.text, "age": self.ageValue.text, "eyeColor": self.eyeColorValue.text, "appearance": self.appearanceValue.text, "skinTone": self.skinToneValue.text, "radius": self.radiusValue.text, "religion": self.religionValue.text, "cityState": self.cityStateValue.text, "bio": self.bioValue.text]
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).child("profile").updateChildValues(values, withCompletionBlock: { (errr, _) in
            if errr == nil {
                print("There is no error in your code ! ")
            }else{
                
            }
        })
        
        var favoriteImageValues = ["A0": "", "A1": "", "A2": "", "A3": "", "A4": "", "A5": "", "A6": "", "A7": "", "A8": "", "A9": "", "A10": "", "A11": "", "A12": "", "A13": "", "A14": "", "A15": "", "A16": "", "A17": "", "A18": "", "A19": "", "A20": "", "A21": "", "A22": "", "A23": "", "A24": "", "A25": "", "A26": "", "A27": "", "A28": "", "A29": "", "A30": "", "A31": ""]



        for i in 0 ..< favoriteImageString.count{

            favoriteImageValues.updateValue(favoriteImageString[i], forKey: "A\(i)")
        }
        
        Database.database().reference().child("users").child(userID!).child("favoriteImages").updateChildValues(favoriteImageValues, withCompletionBlock: { (errr, _) in
            if errr == nil {
                
            }
        })
        
         self.showLoading(state: false)

//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Navigation") as! NavVC
//        self.present(nextViewController, animated:true, completion:nil)
        
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "LMSidebar") as! LMRootViewController
        self.present(vc1, animated:true, completion:nil)
        
    }

    @IBAction func profileImageUpdate(_ sender: Any) {
        
         self.showLoading(state: true)
        
        let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWithPhoto(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWithPhoto(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
        
         self.showLoading(state: false)
        
    }
    
    func openPhotoPickerWithPhoto(source: PhotoSource) {
        
        switch source {
        case .camera:
            profilePhotoFlag = true
            profileImageFlag = false
            let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if (status == .authorized || status == .notDetermined) {
                self.profileImagePicker.sourceType = .camera
                self.profileImagePicker.allowsEditing = true
                self.present(self.profileImagePicker, animated: true, completion: nil)
            }
        case .library:
            profilePhotoFlag = true
            profileImageFlag = false
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.profileImagePicker.sourceType = .savedPhotosAlbum
                self.profileImagePicker.allowsEditing = true
                self.present(self.profileImagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func openPhotoPickerWithImages(source: PhotoSource) {
        
        switch source {
        case .camera:
            profileImageFlag = true
            profilePhotoFlag = false
            let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if (status == .authorized || status == .notDetermined) {
                self.profileImagePicker.sourceType = .camera
                self.profileImagePicker.allowsEditing = true
                self.present(self.profileImagePicker, animated: true, completion: nil)
            }else{
             
            }
        case .library:
            profileImageFlag = true
            profilePhotoFlag = false
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.profileImagePicker.sourceType = .savedPhotosAlbum
                self.profileImagePicker.allowsEditing = true
                self.present(self.profileImagePicker, animated: true, completion: nil)
            }else{
                
            }
        }
    }
    
    //Downloads current user profile 
    func fetchUserProfile() {
        
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                
                self.raceValue.text = data["race"]!
                self.genderValue.text = data["gender"]!
                self.weightValue.text = data["weight"]!
                self.heightValue.text = data["height"]!
                self.ageValue.text = data["age"]!
                self.eyeColorValue.text = data["eyeColor"]!
                self.appearanceValue.text = data["appearance"]!
                self.skinToneValue.text = data["skinTone"]!
                self.radiusValue.text = data["radius"]!
                self.religionValue.text = data["religion"]!
                self.cityStateValue.text = data["cityState"]!
                self.bioValue.text = data["bio"]!

            }
        })
        
        Database.database().reference().child("users").child(userID!).child("favoriteImages").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                
                for i in 0 ..< 32{
                    
                    if (data["A\(i)"]?.characters.count)! > 0{
                        
                        let link = URL.init(string: data["A\(i)"]!)
                        self.favoriteImageString.append(data["A\(i)"]!)
                        
                        URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                            if error == nil {
                                
                                let favoriteImageElement = UIImage.init(data: data!)
                                self.favoriteImageArray.append(favoriteImageElement!)
                                self.imageScrollView.reloadData()
                                
                            }
                        }).resume()
                    }

                    
                }
            }
        })
        
        
        
    }
    
    //Downloads current user credentials
    func fetchUserInfo() {
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    weakSelf?.profileName.text = user.name
//                    weakSelf?.emailLabel.text = user.email
                    weakSelf?.profileImage.image = user.profilePic
                    weakSelf = nil
                }
            })
        }
    }
    
    //UIScrollViewDelegate and DataSource methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ProfileImageCell
        
        cell.profileImage.image = favoriteImageArray[indexPath.row]
        
        cell.profileImage.layer.borderWidth = 2
        cell.profileImage.layer.borderColor = GlobalVariables.purple.cgColor
        
        cell.contentView.clipsToBounds = true
        
        let layer = cell.layer
        let config = GlidingConfig.shared
        layer.shadowOffset = config.cardShadowOffset
        layer.shadowColor = config.cardShadowColor.cgColor
        layer.shadowOpacity = config.cardShadowOpacity
        layer.shadowRadius = config.cardShadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("You did select collectionView Cell.")
        

        
    }
    
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Your app can do something when textfield finishes editing
        print("The textfield ended editing. Do something based on app requirements.")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == citystateTable){
            return citystateValueComponent.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if(tableView == citystateTable){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: citystateCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = citystateValueComponent[indexPath.row]
            cell.textLabel?.font = cityStateValue.font
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: citystateCellReuseIdentifier, for: indexPath as IndexPath)
            
            cell.textLabel?.text = citystateValueComponent[indexPath.row]
            cell.textLabel?.font = cityStateValue.font
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if(tableView == citystateTable){
            
            cityStateValue.text = citystateValueComponent[indexPath.row]
            tableView.isHidden = true
            cityStateValue.endEditing(true)
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            if profilePhotoFlag == true{
                
                let userID = Auth.auth().currentUser?.uid
                
                self.profileImage.image = pickedImage
                
                let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1)
                
                Storage.storage().reference().child("usersProfilePics").child(userID!).putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        
                        print("Good, you are succeed in updating profile image!")
                        
                        let path = metadata?.downloadURL()?.absoluteString
                        
                        let values = ["name": self.userName, "email": self.emailAddress, "profilePicLink": path!]
                        
                        Database.database().reference().child("users").child(userID!).child("credentials").updateChildValues(values, withCompletionBlock:{(error, _) in
                            
                            if error == nil{
                                
                            }else{
                                
                            }
                        })
                        
                    }else{
                        print("Sorry but any error has been occured in updating profile image!")
                    }
                })
                
                profilePhotoFlag = false
                
            }
            
            if profileImageFlag == true{
                
                let userID = Auth.auth().currentUser?.uid
                
                let imageData = UIImageJPEGRepresentation(pickedImage, 0.1)
                
                Storage.storage().reference().child("usersProfilePics").child(userID!).child("\(favoriteImageArray.count)").putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        
                        print("Good, you are succeed in updating profile image!")
                        
                        let path = metadata?.downloadURL()?.absoluteString
                        
                        self.favoriteImageString.append(path!)
                        
                    }else{
                        print("Sorry but any error has been occured in updating profile image!")
                    }
                })
                
                
                favoriteImageArray.append(pickedImage)
                
                self.imageScrollView.reloadData()
                
                profileImageFlag = false
                
            }
          
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        picker.dismiss(animated: true, completion: nil)
        
        profilePhotoFlag = false
        profileImageFlag = false
        
    }

}
