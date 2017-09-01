//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//
import UIKit
import Firebase



class LMLeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //The Titles of Side bar.
    var menuTitles = [0: "Home", 1: "Profile", 2: "Your location", 3: "Personality", 4: "Search",5: "Help", 6: "Log out"]
    //The images of Side bar.
    var cellimage = [0: "home4.png", 1: "user1.png", 2: "pin.png", 3: "filter2.png", 4: "filter1.png", 5:"help.png", 6: "logout.png"]
    
    //initialize.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var toolBar_left: UIToolbar!
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = Auth.auth().currentUser?.uid {
            
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    weakSelf?.avatarImageView.image = user.profilePic
                    weakSelf?.CircleImage(profileImage: self.avatarImageView!)
                    weakSelf = nil
                }
            })
        }
        
       
        self.tableView.register(UINib(nibName: "LelfMenuViewCell", bundle: nil), forCellReuseIdentifier: "LM")
        
    }
    
    //making circle image
    func CircleImage(profileImage: UIImageView) {
        // Circle images
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderWidth = 0.5
        profileImage.layer.borderColor = UIColor.clear.cgColor
        profileImage.clipsToBounds = true
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RemoveMenu(_ sender: Any) {
        self.sideBarController.hideMenuViewController(true)
    }
    // Table View DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LM", for: indexPath) as! LelfMenuViewCell
        cell.titleLabel.text = self.menuTitles[indexPath.row]
        cell.titleLabel.textColor = UIColor(white: 0.0, alpha: 1)
        cell.backgroundColor = UIColor.clear
        cell.cellImage.image = UIImage(named: cellimage[indexPath.row]!)
        return cell
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect( x:0, y:0, width:width, height:height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    // TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var mainNavVC = NavVC()
        mainNavVC = self.sideBarController.contentViewController as! NavVC
        
        if(indexPath.row == 0){
            mainNavVC.showHomeViewController()
        }else if(indexPath.row == 1){
            mainNavVC.showProfileViewController()
        }else if(indexPath.row == 2){
            mainNavVC.showMapViewController()
        }else if(indexPath.row == 3){
            mainNavVC.showQuestionViewController()
        }else if(indexPath.row == 4){
            mainNavVC.showFilterSettingViewController()
        }else if(indexPath.row == 5){
            mainNavVC.showHelpViewController()
        }else if(indexPath.row == 6){
            User.logOutUser { (status) in
                if status == true {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }else{
            
        }
        
        self.sideBarController.hideMenuViewController(true)
    }
    
}
