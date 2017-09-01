//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import CoreLocation

class User: NSObject {
    
    //MARK: Properties
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage


    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                user?.sendEmailVerification(completion: nil)
                let storageRef = Storage.storage().reference().child("usersProfilePics").child(user!.uid)
                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        let path = metadata?.downloadURL()?.absoluteString
                        let values = ["name": withName, "email": email, "profilePicLink": path!]
                        Database.database().reference().child("users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                let userInfo = ["email" : email, "password" : password]
                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                completion(true)
                            }
                        })
                        
                        let profileValues = ["race": "", "gender": "", "weight": "", "height": "", "age": "", "eyeColor": "", "appearance": "", "skinTone": "", "radius": "", "religion": "", "cityState": "", "bio": ""]
                        
                        Database.database().reference().child("users").child((user?.uid)!).child("profile").updateChildValues(profileValues, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                
                                completion(true)
                            }
                        })
                        
                        let playerID = ["playerID": ""]
                        
                        Database.database().reference().child("users").child((user?.uid)!).child("playerID").updateChildValues(playerID, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                
                                completion(true)
                            }
                        })
                        
                        let favoriteImageValues = ["A0": "", "A1": "", "A2": "", "A3": "", "A4": "", "A5": "", "A6": "", "A7": "", "A8": "", "A9": "", "A10": "", "A11": "", "A12": "", "A13": "", "A14": "", "A15": "", "A16": "", "A17": "", "A18": "", "A19": "", "A20": "", "A21": "", "A22": "", "A23": "", "A24": "", "A25": "", "A26": "", "A27": "", "A28": "", "A29": "", "A30": "", "A31": ""]
                        
                        Database.database().reference().child("users").child((user?.uid)!).child("favoriteImages").updateChildValues(favoriteImageValues, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                
                                completion(true)
                            }
                        })
                        
                        let questionnaireValues = ["Music": "", "Dating": "", "Lifestyle": "", "Careertype": "", "Lifemotto": "", "ManualItem": ""]
                        
                        Database.database().reference().child("users").child((user?.uid)!).child("questionnaire").updateChildValues(questionnaireValues, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                
                                completion(true)
                            }
                        })
                        

                        
                    }
                })
            }
            else {
                completion(false)
            }
        })
    }
    
    class func profileUpdate(forUserID: String, race: String, gender: String, weight: Double, height: Double, age: Double, eyeColor: String, appearance: String, skinTone: String, radius: Double, religion: String, cityState: String, bio: String, favoriteImage: Array<Any>, completion: @escaping (User) -> Swift.Void) {
        
        let values = ["race": race, "gender": gender, "weight": weight, "height": height, "age": age, "eyeColor": eyeColor, "appearance": appearance, "skinTone": skinTone, "radius": radius, "religion": religion, "cityState": cityState, "bio": bio] as [String : Any]
        
        
        var values1 = [String]()
        values1 = ["array1", "array2"]
        
        Database.database().reference().child("users").child(forUserID).child("profile").updateChildValues(values, withCompletionBlock: { (errr, _) in
            if errr == nil {
                print("There is any error in your code ! ")
            }
        })
    }
    
   class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
    
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
   class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
    
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let name = data["name"]!
                let email = data["email"]!
                let link = URL.init(string: data["profilePicLink"]!)
                
                print("this is user image link : \(String(describing: link))")
                
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: forUserID, profilePic: profilePic!)
                        completion(user)
                    }
                }).resume()
                
            }
        })
    }
    
    class func downloadAllUsers(exceptID: String, completion: @escaping (User) -> Swift.Void) {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["credentials"] as! [String: String]
            if id != exceptID {
                let name = credentials["name"]!
                let email = credentials["email"]!
                let link = URL.init(string: credentials["profilePicLink"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: id, profilePic: profilePic!)
                        completion(user)
                    }
                }).resume()
            }

        })

    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }

    
    //MARK: Inits
    init(name: String, email: String, id: String, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }
}

