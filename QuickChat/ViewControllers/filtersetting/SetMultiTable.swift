//
//  SettingsTableViewController.swift
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//


import UIKit

class SetMultiTable: SetTable {
    
    //MARK:VARIABLES
    
    internal var sectionTitles:[String] = [""];
    internal var cellKeys:[[String]] = [[""]];
    internal var cellDisplayTypes:[[String]] = [[""]];
    
    //MARK:-
    //MARK:BUILD
    
    // number of section(s)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellKeys.count;
    }
    
    //number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellKeys[section].count;
    }
    
    
    //title text in each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section];
    }
    
    //build out rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //get id and create cell row
        let cellKey:String = cellKeys[indexPath.section][indexPath.row]
        
        //get cell data
        if let cellDataObj:SetCellDataObj = data.getDataObjForKey(cellKey) {
            
            //get display type and return a custom cell based on it
            let displayType:String = cellDisplayTypes[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            
            //toggle switch
            if (displayType == DISPLAY_TYPE_SWITCH){
                
                return SetToggleCell(
                    style: .default,
                    reuseIdentifier: cellKey,
                    data: cellDataObj)
                
                //disclosure arrow - leads to subview
            } else if (displayType == DISPLAY_TYPE_DISCLOSURE){
                
                return SetDisclosureCell(
                    style: .value1,
                    reuseIdentifier: cellKey,
                    data: cellDataObj as! SetDisclosureCellDataObj)
                
                //checkmark - off and on
            } else {
                if (debug){
                    print("SETTINGS: Error determining cell display type");
                }
                return UITableViewCell()
            }
            
            //else return generic empty cell
        } else {
            if (debug){
                print("SETTINGS: Error accessing cell data object");
            }
            return UITableViewCell()
        }

        
        
    }

    
}
