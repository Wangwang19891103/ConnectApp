//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//


import Foundation
import UIKit

//Global variables
struct GlobalVariables {
    static let blue = UIColor.rbg(r: 4, g: 113, b: 204)
    static let purple = UIColor.rbg(r: 97, g: 166, b: 225)
}

//Extensions
extension UIColor{
    class func rbg(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        return color
    }
}

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class ProfileImageView: UIImageView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 8
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
}

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

class NoCopyPasteUITextField: UITextField {
    
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        if (action == #selector(self.copy(_:))) {
            return false
        } else if (action == #selector(self.paste(_:))) {
            return false
        } else if (action == #selector(self.select(_:))) {
            return false
        } else if (action == #selector(self.selectAll(_:))) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
}


//Enums
enum ViewControllerType {
    case welcome
    case conversations
}

enum PhotoSource {
    case library
    case camera
}

enum ShowExtraView {
    case contacts
    case profile
    case preview
    case map
}

enum MessageType {
    case photo
    case text
    case location
}

enum MessageOwner {
    case sender
    case receiver
}
