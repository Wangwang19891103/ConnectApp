
import UIKit

class SetMIDISync: SetCheckmarkTable {
    
    override func viewDidLoad() {
        
        //set vars before calling super

        title = "MIDI Clock"
        parentCellKey = data.KEY_MIDI_SYNC;
        
        super.viewDidLoad()
        
    }
    
}

class SetAppearance: SetCheckmarkTable {
    
    override func viewDidLoad() {
        
        //set vars before calling super
        
        title = "Appearance"
        parentCellKey = data.KEY_APPEARANCE;
        
        super.viewDidLoad()
        
    }
    
}

class SetCityState: SetCheckmarkTable {
    
    override func viewDidLoad() {
        
        //set vars before calling super
        
        title = "City & State"
        parentCellKey = data.KEY_CITYSTATE;
        
        super.viewDidLoad()
        
    }
    
}



