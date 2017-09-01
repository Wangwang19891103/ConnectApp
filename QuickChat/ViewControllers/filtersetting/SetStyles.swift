//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class SetStyles {
    
    //singleton code
    static let sharedInstance = SetStyles();
    fileprivate init() {}
    
    internal let GREY_LIGHT:UIColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0);
    internal let GREY_MID:UIColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.0);
    internal let GREY_MID_DARK:UIColor = UIColor(red:0.66, green:0.66, blue:0.66, alpha:1.0);
    internal let GREY_DARK:UIColor = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1.0);
    internal let TABLE_BORDER_WIDTH:CGFloat = 0.5;
    
}

