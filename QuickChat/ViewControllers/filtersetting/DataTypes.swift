//
//  DefaultDataTypes.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation

class DataTypes {
    
    //data types
    internal let TYPE_BOOL:String = "bool";
    internal let TYPE_OBJECT:String = "object";
    internal let TYPE_INTEGER:String = "integer";
    
    //singleton code
    static let sharedInstance = DataTypes();
    fileprivate init() {}
    

}
