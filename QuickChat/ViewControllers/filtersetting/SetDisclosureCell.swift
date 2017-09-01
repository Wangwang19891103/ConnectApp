//
//  SettingsDisclosureCell.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class SetDisclosureCell: SetCell {
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, data:SetDisclosureCellDataObj){
        
        super.init(style:style, reuseIdentifier:reuseIdentifier, data:data);
    
        self.accessoryType = .disclosureIndicator
        self.detailTextLabel?.text = data.defaultLabel
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    }
    
    //updates text back on the disclosure cell display that opened the new table
    internal func updateDefaultLabelDisplay(){
        self.detailTextLabel?.text = (data as! SetDisclosureCellDataObj).defaultLabel;
    }
    
    
}

