//
//  DefaultBoolData.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation

class SetCheckmarkCellDataObj:SetCellDataObj {
    
    //MARK:-
    //MARK:VARIABLES
    
    internal var value:Any = "";
    internal var selected:Bool = false;
    
    //MARK:-
    //MARK:INIT
    init(key:String, value:Any, selected:Bool, label:String, type:String){
        
        //the key in this class is the parent key, the key that these values assign to
        super.init(key: key ,label: label, type: type);
        self.value = value;
        self.selected = selected;
        
    }
    

    
}
