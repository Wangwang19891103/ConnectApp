//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation

// :nodoc:
extension Collection {
  subscript(safe index: Index) -> Generator.Element? {
    return index >= startIndex && index < endIndex ? self[index] : nil
  }
}
