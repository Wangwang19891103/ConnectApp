//
//  SettingsCheckmarkCell.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class SetCheckmarkCell: SetCell {
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, data:SetCheckmarkCellDataObj){
        
        super.init(style:style, reuseIdentifier:reuseIdentifier, data:data);
        
        //check default and set this cell to checkmark or none
        
        if (data.selected){
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    }
    
    
}

