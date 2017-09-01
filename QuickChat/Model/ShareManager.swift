//
//  ShareManager.swift
//  QuickChat
//
//  Created by MyCom on 7/6/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation
import CoreLocation

class SharingManager {
    
    static let sharedInstance = SharingManager()
    
    var userLocationArray = [CLLocationCoordinate2D]()
    
    var filteredUserLocationArray = [CLLocationCoordinate2D]()
    
    var userCredentialID = [String]()
    
    var filteredUID = [String]()
    
    var userIDCount = [String: Int]()
    
    var userIDMarker = [Dictionary<String, Any>]()
    
    var userIDLocation = [Dictionary<String, Any>]()
    
    var connectorProfile = [Dictionary<String, Any>]()
}
