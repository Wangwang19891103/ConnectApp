///
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class LMOtherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func leftMenuButtonTapped(_ sender: Any){
        
        self.sideBarController.showMenuViewController(in: LMSideBarControllerDirection.left)
    }
}
