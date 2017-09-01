//
//  Created by MyCom on 7/5/17.
//  Copyright © 2017 Mexonis. All rights reserved.
//

import Foundation

/// Datasource protocol of GlidingCollection.
public protocol GlidingCollectionDatasource {
  
  /// Number of items in vertical stack of items.
  ///
  /// - Parameter collection: GlidingCollection
  /// - Returns: number of items in stack
  func numberOfItems(in collection: GlidingCollection) -> Int
  
  /// Item at given index.
  ///
  /// - Parameters:
  ///   - collection: GlidingCollection
  ///   - index: index of item
  /// - Returns: item title
  func glidingCollection(_ collection: GlidingCollection, itemAtIndex index: Int) -> String
  
}
