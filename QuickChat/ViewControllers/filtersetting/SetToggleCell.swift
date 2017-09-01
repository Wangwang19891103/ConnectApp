//
//  SettingsToggleCell
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import UIKit

class SetToggleCell: SetCell {
    
    //MARK:INIT
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?, data:SetCellDataObj){
        
        super.init(style:style, reuseIdentifier:reuseIdentifier, data:data);
        
        //create switch
        let toggleSwitch:UISwitch = UISwitch();
        
        //add a function that gets called when the user changes the switch
        toggleSwitch.addTarget(self, action: #selector(updateSwitchAtIndexPath), for: .touchUpInside);
        
        //set the toggle based on the data
        toggleSwitch.isOn = data.defaultValue as! Bool;
        
        //add the switch to the row cell
        self.accessoryView = UIView(frame:toggleSwitch.frame);
        self.accessoryView?.addSubview(toggleSwitch);
        self.selectionStyle = .none;
        
        //use default style
        //self.accessoryView?.backgroundColor = UIColor.black
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder);
    }
    
    //MARK:USER INPUT
    
    //user toggles switch, update defaults value
    internal func updateSwitchAtIndexPath(_ sender:UISwitch){
        defaultsManager.setValueForKey(type: dataTypes.TYPE_BOOL, value: sender.isOn, key: (data?.key)!)
    }

    
   
}

