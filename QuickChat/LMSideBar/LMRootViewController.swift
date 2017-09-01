//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class LMRootViewController: LMSideBarController, LMSideBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Init side bar styhles
        
        let sideBarDepthStyle: LMSideBarDepthStyle = LMSideBarDepthStyle()
        sideBarDepthStyle.menuWidth = 220
        
        // Init view controllers
        let leftMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "leftMenuViewController") as! LMLeftMenuViewController
        let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! NavVC
        
        // Setup side bar controller
        self.panGestureEnabled = true
        self.delegate = self
        self.setMenuView(leftMenuViewController, for: LMSideBarControllerDirection.left)
        self.setSideBarStyle(sideBarDepthStyle, for: LMSideBarControllerDirection.left)
        self.contentViewController = navigationController
    }
    
    // Side bar Delegate    
    func sideBarController(_ sideBarController: LMSideBarController!, willShowMenuViewController menuViewController: UIViewController!) {
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
    }
    
    func sideBarController(_ sideBarController: LMSideBarController!, didShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideBarController(_ sideBarController: LMSideBarController!, willHideMenuViewController menuViewController: UIViewController!) {
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
    }
    
    func sideBarController(_ sideBarController: LMSideBarController!, didHideMenuViewController menuViewController: UIViewController!) {
        
    }
    
}
