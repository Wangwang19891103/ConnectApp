//
//  SettingsTableViewController.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//


import UIKit

class SetCheckmarkTable: SetTable {
    
    //MARK:VARIABLES
    
    //table key
    internal var parentCell:SetDisclosureCell?
    internal var parentCellData:SetDisclosureCellDataObj?
    internal var parentCellKey:String = ""
    
    //MARK:-
    //MARK:BUILD
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //grab data object for whole table rather than each cell
        //cells will be populated with table datas sub arrays
        parentCellData = data.getDataObjForKey(parentCellKey) as? SetDisclosureCellDataObj
        
    }
    
    // number of section(s)
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //checkmark list are just 1 section
        return 1;
    }
    
    
    //number of rows in each section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (parentCellData != nil){
            
            return (parentCellData?.subLabels.count)!;
            
        } else {
            if (debug){
                print("SETTINGS: Checkmark table data is nil while getting number of rows")
            }
            return 0;
        }
    }
     
    
    //title text in each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //no title to section
        return "";
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (parentCellData != nil){
            
            //record parent values
            let parentCellKey:String = (parentCellData?.key)!
            let parentCellType:String = (parentCellData?.type)!
            
            //record values for this cell
            let cellValue:Any = parentCellData!.subValues[indexPath.row]
            let cellLabel:String = (parentCellData?.subLabels[indexPath.row])!
            var cellSelected:Bool = false;
            
            //if this row is the default position, then set selected to true
            if (parentCellData?.defaultPosition == indexPath.row){
                cellSelected = true;
            }
            
            //make a checkmark cell data obj
            let cellDataValueObj:SetCheckmarkCellDataObj = SetCheckmarkCellDataObj(
                key: parentCellKey,
                value: cellValue,
                selected: cellSelected,
                label: cellLabel,
                type: parentCellType
            )
            
            //return a checkmark cell
            return SetCheckmarkCell(
                style: .default,
                reuseIdentifier: String(describing: cellValue),
                data: cellDataValueObj)
            
            
        } else {
            if (debug){
                print("SETTINGS: Checkmark table data is nil while building rows");
            }
            return UITableViewCell();
        }
       
    }
    
    //MARK:-
    //MARK: USER INPUT
    
    //user taps row

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (debug){
            print("Select row", (indexPath as NSIndexPath).row)
        }
        
        //turn off all checkmarks
        self.resetCheckmarks()
        
        //confirm cell is a checkmark cell
        if let cell:SetCheckmarkCell = tableView.cellForRow(at: indexPath) as? SetCheckmarkCell {
            
            //update visual and bool to selected
            cell.accessoryType = .checkmark
            cell.isSelected = true;
            
            //change color of highlight
            let highlightCell:UIView = UIView(frame:cell.frame)
            highlightCell.backgroundColor = styles.GREY_MID
            cell.selectedBackgroundView =  highlightCell;
            
            
            //update the parent disclosure cell data so this change is remembered in the GUI
            if (parentCellData != nil){
                parentCellData?.setNewDefault(newIndex: indexPath.row)
                
            } else {
                if (debug){
                    print("SETTINGS: Error updating parent cell data during checkmark table row tap")
                }
            }
            
            if (parentCell != nil){
                parentCell?.updateDefaultLabelDisplay()
            }
            
        }
        
        //deselect row so the grey background flashes
        tableView.deselectRow(at: indexPath, animated: true)
        
        _ = navigationController?.popViewController(animated: true)

        
    }
    
    func resetCheckmarks() {
        for i in 0..<tableView.numberOfSections {
            for j in 0..<tableView.numberOfRows(inSection: i) {
                if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
                    cell.accessoryType = .none
                }
            }
        }
    }
    
}
