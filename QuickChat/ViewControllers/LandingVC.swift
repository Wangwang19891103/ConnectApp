//  Created by MyCom on 7/11/17.
//  Copyright © 2017 Mexonis. All rights reserved.


import UIKit


class LandingVC: UIViewController {
    
    //MARK: Properties
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }

    //MARK: Push to relevant ViewController
    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
        case .conversations:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavVC
            let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "LMSidebar") as! LMRootViewController
            self.present(vc1, animated: false, completion: nil)
        case .welcome:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") as! WelcomeVC
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //MARK: Check if user is signed in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
            User.loginUser(withEmail: email, password: password, completion: { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if status == true {
                        weakSelf?.pushTo(viewController: .conversations)
                    } else {
                        weakSelf?.pushTo(viewController: .welcome)
                    }
                    weakSelf = nil
                }
            })
        } else {
            self.pushTo(viewController: .welcome)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
