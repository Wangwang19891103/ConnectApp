//
//  DefaultsManager.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation

class DefaultsManager {
    
    //singleton code
    static let sharedInstance = DefaultsManager();
    
    //connect to NS user defaults
    internal let defaults:UserDefaults = UserDefaults.standard;
    
    //data types
    internal let dataTypes:DataTypes = DataTypes.sharedInstance

    internal let debug:Bool = true;
    
    fileprivate init(){}

    
    //MARK: GETTERS
    internal func getBoolForKey(_ key:String) -> Bool{
        return defaults.bool(forKey: key)
    }
    
    internal func getIntegerForKey(_ key:String) -> Int{
        return defaults.integer(forKey: key);
    }
    
    internal func getObjectForKey(_ key:String) -> AnyObject?{
        return defaults.object(forKey: key) as AnyObject?
    }
    
    //MARK: SETTERS
    
    //used by checkmark cells
    internal func setValueForKey(type:String, value:Any, key:String){
        defaults.set(value, forKey: key)
    }
    
    //used by toggle cells
    internal func setBoolForKey(_ bool:Bool, key:String){
        defaults.set(bool, forKey: key)
    }
    
    
}
