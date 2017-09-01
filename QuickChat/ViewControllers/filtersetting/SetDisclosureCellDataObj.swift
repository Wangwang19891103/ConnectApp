//
//  DefaultBoolData.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation

class SetDisclosureCellDataObj:SetCellDataObj {
    
    //MARK:-
    //MARK:VARIABLES

    //multi values
    internal var subValues:[Any] = [];
    internal var subLabels:[String] = [];
    
    //defaults
    internal var defaultLabel:String = "";
    internal var defaultPosition:Int = 0;
    
    //MARK:-
    //MARK:INIT
    override init(key:String, label:String, type:String){
        
        super.init(key: key ,label: label, type: type);
        
    }
    
    internal func initSubArrays(values:[Any], labels:[String]){
        
        //record arrays
        self.subValues = values;
        self.subLabels = labels;
        
        //find the default position in the arrays but comparing it to default object set in init func
        for i in 0..<subValues.count {
            
            let value:Any = subValues[i];
            
            //convert values to strings and compare them
            if (String(describing: value) == String(describing: defaultValue)){
                
                //record the default position (this will be the selected cell in a view)
                defaultPosition = i;
                defaultLabel = self.subLabels[i]
                
                if (debug){
                    print("DEFAULTS: Position is", defaultPosition, "label is", defaultLabel);
                }
            }
            
        }
        
    }
    
    internal func setNewDefault(newIndex:Int){
        
        //update local variables
        defaultPosition = newIndex;
        defaultLabel = subLabels[newIndex]
        defaultValue = subValues[newIndex]
        
        defaultsManager.setValueForKey(type:type, value:defaultValue, key:key);
    }
    
}
