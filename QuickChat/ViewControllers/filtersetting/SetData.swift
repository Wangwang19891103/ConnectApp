//
//  DefaultsData.swift
//  RF Settings
//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation

class SetData {
    
    //singleton code
    static let sharedInstance = SetData();

    //MARK:-
    //MARK:VARIABLES
    
    //data types
    internal let types:DataTypes = DataTypes.sharedInstance;
    
    //data objs
    internal var dataObjs:[SetCellDataObj] = [];
    
    //top level keys
    internal let KEY_BG_PHOTO:String = "bg_photo";
    internal let KEY_INFO_DISPLAY:String = "info_display";
    internal let KEY_MIDI_SEND_ENABLED:String = "midi_send_enabled";
    internal let KEY_MIDI_RECEIVE_ENABLED:String = "midi_receive_enabled";
    internal let KEY_MIDI_SYNC:String = "midi_sync";
    
    
    internal let KEY_AGE:String = "age"
    internal let KEY_GENDER:String = "gender"
    internal let KEY_RELIGION:String = "religion"
    internal let KEY_HEIGHT:String = "height"
    internal let KEY_WEIGHT:String = "weight"
    internal let KEY_RACE:String = "race"
    internal let KEY_EYECOLOR:String = "eyecolor"
    
    internal let KEY_APPEARANCE:String = "appearance"
    internal let KEY_CITYSTATE:String = "citystate"
    
    internal let KEY_SKINTONE:String = "skintone"
    
    
    internal let KEY_INSTR_OUTS:[String] =
        ["instr_0_out",
         "instr_1_out",
         "instr_2_out",
         "instr_3_out"
    ]

    
    //sub level keys
    internal let KEY_MIDI_CLOCK_RECEIVE:String = "midi_clock_receive";
    internal let KEY_MIDI_CLOCK_SEND:String = "midi_clock_send";
    internal let KEY_MIDI_CLOCK_NONE:String = "midi_clock_none";
    
    internal let KEY_APPEARANCE_SLENDER:String = "slender"
    internal let KEY_APPEARANCE_AVERAGE:String = "average"
    internal let KEY_APPEARANCE_ATHLETIC:String = "athletic"
    internal let KEY_APPEARANCE_HEAVYSET:String = "heavyset"
    
    internal let KEY_CITYSTATE_TEXAS:String = "Dallas"
    internal let KEY_CITYSTATE_CALIFONIA:String = "LosAngeles"
    internal let KEY_CITYSTATE_NEVADA:String = "LasVegas"
    internal let KEY_CITYSTATE_NEWMEXICO:String = "ElPaso"
    internal let KEY_CITYSTATE_FLORIDA:String = "Miami"
    internal let KEY_CITYSTATE_MICHIGAN:String = "Detroit"
    internal let KEY_CITYSTATE_OREGON:String = "Portland"
    internal let KEY_CITYSTATE_WASHINGTON:String = "Seattle"
    
    
    //MARK:-
    //MARK: INIT
    fileprivate init() {
        
        //bool objects
        let bgPhoto:SetCellDataObj = SetCellDataObj(
            key: KEY_BG_PHOTO,
            label: "Age",
            type: types.TYPE_BOOL);
        
        let infoDisplay:SetCellDataObj = SetCellDataObj(
            key: KEY_INFO_DISPLAY,
            label: "Religion",
            type: types.TYPE_BOOL);
        
        let midiSend:SetCellDataObj = SetCellDataObj(
            key: KEY_MIDI_SEND_ENABLED,
            label: "Height",
            type: types.TYPE_BOOL);
        
        let midiReceive:SetCellDataObj = SetCellDataObj(
            key: KEY_MIDI_RECEIVE_ENABLED,
            label: "Weight",
            type: types.TYPE_BOOL);
        
        /*****************************/
        
        let age:SetCellDataObj = SetCellDataObj(
            key: KEY_AGE,
            label: "Age",
            type: types.TYPE_BOOL);
        
        let gender:SetCellDataObj = SetCellDataObj(
            key: KEY_GENDER,
            label: "Gender",
            type: types.TYPE_BOOL);
        
        let height:SetCellDataObj = SetCellDataObj(
            key: KEY_HEIGHT,
            label: "Height",
            type: types.TYPE_BOOL);
        
        let weight:SetCellDataObj = SetCellDataObj(
            key: KEY_WEIGHT,
            label: "Weight",
            type: types.TYPE_BOOL);
        
        let eyecolor:SetCellDataObj = SetCellDataObj(
            key: KEY_EYECOLOR,
            label: "Eye Color",
            type: types.TYPE_BOOL);
        
        let religion:SetCellDataObj = SetCellDataObj(
            key: KEY_RELIGION,
            label: "Religion",
            type: types.TYPE_BOOL);
        
        let race:SetCellDataObj = SetCellDataObj(
            key: KEY_RACE,
            label: "Race",
            type: types.TYPE_BOOL);
        
        let appearance:SetDisclosureCellDataObj = SetDisclosureCellDataObj(
            key: KEY_APPEARANCE,
            label: "Appearance",
            type: types.TYPE_OBJECT);
        
        appearance.initSubArrays(values: [KEY_APPEARANCE_SLENDER, KEY_APPEARANCE_AVERAGE, KEY_APPEARANCE_ATHLETIC, KEY_APPEARANCE_HEAVYSET], labels: ["Slender", "Average", "Athletic/Toned", "Heavyset"])
        
        let citystate:SetDisclosureCellDataObj = SetDisclosureCellDataObj(
            key: KEY_CITYSTATE,
            label: "citystate",
            type: types.TYPE_OBJECT);
        
        citystate.initSubArrays(values: [KEY_CITYSTATE_TEXAS, KEY_CITYSTATE_CALIFONIA, KEY_CITYSTATE_NEVADA, KEY_CITYSTATE_NEWMEXICO, KEY_CITYSTATE_FLORIDA, KEY_CITYSTATE_MICHIGAN, KEY_CITYSTATE_OREGON, KEY_CITYSTATE_WASHINGTON], labels: ["Dallas, TEXAS", "Los Angeles, CALIFONIA", "Las Vegas, NEVADA", "El Paso, NEW MEXICO", "Miami, FLORIDA", "Detroit, MICHIGAN", "Portland, OREGON", "Seattle, WASHINGTON"])
        
        
        //simple multi object (3 options)
        let midiSync:SetDisclosureCellDataObj = SetDisclosureCellDataObj(
            key: KEY_MIDI_SYNC,
            label: "questionnaire item1",
            type: types.TYPE_OBJECT);
        
        midiSync.initSubArrays(
            values:[KEY_MIDI_CLOCK_RECEIVE, KEY_MIDI_CLOCK_SEND, KEY_MIDI_CLOCK_NONE],
            labels: ["subitem 1", "subitem 2", "None"])
        
        //add these to the array for later ref
        dataObjs = [age, gender, height, weight, eyecolor, religion, race, midiSync, appearance, citystate]
        
        //... then execute loops to create the 16 MIDI channel options for each of the 7 instruments
        
        //loop through and populate MIDI channels and labels
        
        var midiOutChannels:[Int] = [];
        var midiOutLabels:[String] = [];
        
        for i in 0...15 {
            midiOutChannels.append(i);
            midiOutLabels.append("MIDI Channel " + String(i + 1));
        }
        
        //loop through and create 7 midi outs, one for each instrument
        for i in 0..<KEY_INSTR_OUTS.count {
            
            let midiOut:SetDisclosureCellDataObj = SetDisclosureCellDataObj(
                
                key: KEY_INSTR_OUTS[i],
                label: "Instrument " + String(i + 1),
                type: types.TYPE_INTEGER);
            
            midiOut.initSubArrays(values: midiOutChannels, labels: midiOutLabels)
            
            //add to data objs array
            dataObjs.append(midiOut);
            
        }
        
    }
    
    //MARK:-
    //MARK:ACCESSORS
    
    internal func getDataObjForKey(_ key:String) -> SetCellDataObj? {
        
        for dataObj in dataObjs {
            if (dataObj.key == key){
                return dataObj;
            }
        }
        
        return nil;
    }
    
}
