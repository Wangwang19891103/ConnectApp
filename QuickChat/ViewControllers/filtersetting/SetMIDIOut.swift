
import UIKit

class SetMIDIOut: SetCheckmarkTable {
    
    override func viewDidLoad() {
        
        //set vars before calling super
        
        title = "MIDI Outs"
        
        super.viewDidLoad()
        
    }
    
    internal func setChannel(_ channel:Int){
        parentCellKey = data.KEY_INSTR_OUTS[channel]
    }

    
}

