//
//  DefaultBoolData.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation

class SetCellDataObj {
    
    //MARK:-
    //MARK:VARIABLES
    
    //connect to user defaults
    internal let defaultsManager:DefaultsManager = DefaultsManager.sharedInstance
    
    //types
    internal let types:DataTypes = DataTypes.sharedInstance;
    
    //basics
    internal var key:String = "";
    internal var label:String = "";
    internal var type:String = "";
    
    //defaults
    internal var defaultValue:Any = "";
    
    internal let debug:Bool = false;
    
    //MARK:-
    //MARK:INIT
    init(key:String, label:String, type:String){
        
        //record key, label, and type
        self.key = key;
        self.label = label;
        self.type = type;
        
        //get default values from NSDefaults
        if (type == types.TYPE_BOOL){
            
            defaultValue = defaultsManager.getBoolForKey(key);
            if (debug){
                print("DEFAULTS: Bool for", key, "is", defaultValue);
            }
            
        } else if (type == types.TYPE_INTEGER) {
            
            defaultValue = defaultsManager.getIntegerForKey(key);
            if (debug){
                print("DEFAULTS: Int for", key, "is", defaultValue);
            }
            
        } else if (type == types.TYPE_OBJECT) {
            
            defaultValue = defaultsManager.getObjectForKey(key)!;
            if (debug){
                print("DEFAULTS: Obj for", key, "is", defaultValue);
            }
            
        }

    }
            
}
