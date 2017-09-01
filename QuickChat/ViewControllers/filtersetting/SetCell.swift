//
//  SettingsCell.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class SetCell: UITableViewCell {
    
    //MARK:VARIABLES
    
    internal let defaultsManager:DefaultsManager = DefaultsManager.sharedInstance
    internal var data:SetCellDataObj?;
    internal let dataTypes:DataTypes = DataTypes.sharedInstance
    
    internal let styles:SetStyles = SetStyles.sharedInstance
    
    internal let debug:Bool = true;
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, data:SetCellDataObj){
        
        super.init(style:style, reuseIdentifier:reuseIdentifier);
        
        self.data = data as SetCellDataObj
        
        self.textLabel?.text = data.label;
        
        //use defaults
        //self.layer.borderWidth = styles.TABLE_BORDER_WIDTH;
        //self.layer.borderColor = styles.GREY_MID.cgColor;

        //self.backgroundColor = UIColor.black
        //self.contentView.backgroundColor = UIColor.black
        //self.textLabel?.textColor = UIColor.white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    }
    
}

