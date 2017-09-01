//
//  ConnectProfileVC.swift
//  QuickChat
//
//  Created by MyCom on 7/19/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit
import Firebase

class ConnectProfileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: RoundedImageView!
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
    @IBOutlet weak var bioContentValue: UILabel!
    @IBOutlet weak var imageScrollView: UICollectionView!
    
    var favoriteImageArray = [UIImage]()
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

         NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessage"), object: nil)
        
        self.fetchUserProfile()
        
        self.profileImage.layer.borderColor = GlobalVariables.blue.cgColor
        self.profileImage.layer.borderWidth = 2
        
        imageScrollView.delegate = self
        imageScrollView.dataSource = self
        
        self.imageScrollView.reloadData()
        
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
    }
    
    func pushToUserMesssages(notification: NSNotification) {
        
        if let user = notification.userInfo?["user"] as? User {
            self.user = user
            self.performSegue(withIdentifier: "mapchat", sender: self)
        }
        
    }
    
    //Downloads current user profile
    func fetchUserProfile() {
        
        if self.user?.id != nil{
            
            User.info(forUserID: (self.user?.id)!, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    
                    weakSelf?.user = user
                    weakSelf?.profileImage.image = user.profilePic
                    weakSelf = nil
                }
            })
            
            Database.database().reference().child("users").child((self.user?.id)!).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
                if let data = snapshot.value as? [String: String] {
                    
                    self.raceValue.text = data["race"]!
                    self.genderValue.text = data["gender"]!
                    self.weightValue.text = data["weight"]!
                    self.heightValue.text = data["height"]!
                    self.ageValue.text = data["age"]!
                    self.eyeColorValue.text = data["eyeColor"]!
                    self.appearanceValue.text = data["appearance"]!
                    self.skintoneValue.text = data["skinTone"]!
                    self.radiusValue.text = data["radius"]!
                    self.religionValue.text = data["religion"]!
                    self.citystateValue.text = data["cityState"]!
                    self.connectorName.text = self.user?.name
                    self.bioContentValue.text = data["bio"]!
                    
                }
            })
            
            Database.database().reference().child("users").child((self.user?.id)!).child("favoriteImages").observeSingleEvent(of: .value, with: { (snapshot) in
                if let data = snapshot.value as? [String: String] {
                    
                    for i in 0 ..< 32{
                        
                        if (data["A\(i)"]?.characters.count)! > 0{
                            
                            let link = URL.init(string: data["A\(i)"]!)
                            
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

    }
    
    @IBAction func btnConnect(_ sender: Any) {
        
        self.performSegue(withIdentifier: "mapchat", sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteImageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteImageCell
        
        cell.favoriteImage.image = favoriteImageArray[indexPath.row]
        
        cell.favoriteImage.layer.borderWidth = 2
        cell.favoriteImage.layer.borderColor = GlobalVariables.purple.cgColor

        
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
}
