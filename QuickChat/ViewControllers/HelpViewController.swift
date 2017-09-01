//
//  HelpViewController.swift
//  QuickChat
//
//  Created by MyCom on 8/26/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "setting3")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(FilterSettingViewController.sideBarMenu))
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.leftButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideBarMenu(){
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
