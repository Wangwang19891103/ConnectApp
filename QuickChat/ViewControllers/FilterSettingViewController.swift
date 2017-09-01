//
//  FilterSettingViewController.swift
//  QuickChat
//
//  Created by MyCom on 8/26/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class FilterSettingViewController: UIViewController {
    
    
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "setting3")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(FilterSettingViewController.sideBarMenu))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.leftButton

        // Do any additional setup after loading the view, typically from a nib.
        
        let settingsMain:SetMain = SetMain();
        self.view.addSubview(settingsMain.view)
        
        
        let nav:UINavigationController = UINavigationController();
        nav.viewControllers = [settingsMain];
        settingsMain.nav = nav
        nav.navigationBar.isHidden = true
        
        self.view.addSubview(nav.view);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideBarMenu(){
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }
    
    func action(){
        
    }

}
