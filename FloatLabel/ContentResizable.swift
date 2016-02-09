//
//  ContentResizable.swift
//  FloatLabel
//
//  Created by Justin Driscoll on 2/8/16.
//  Copyright © 2016 Justin Driscoll. All rights reserved.
//

import UIKit

protocol ContentResizable {
  func preferredContentSizeCategoryDidChange(newPreferredSize: NSString)
}

extension UIView: ContentResizable {
  func preferredContentSizeCategoryDidChange(newPreferredSize: NSString) {
    for subview in subviews {
      subview.preferredContentSizeCategoryDidChange(newPreferredSize)
    }
  }
}

class MyLabel: UILabel {
  override func preferredContentSizeCategoryDidChange(newPreferredSize: NSString) {
    switch newPreferredSize {
    case UIContentSizeCategoryExtraSmall:
      self.font = UIFont.systemFontOfSize(10)
    case UIContentSizeCategorySmall:
      self.font = UIFont.systemFontOfSize(12)
    case UIContentSizeCategoryMedium:
      self.font = UIFont.systemFontOfSize(15)
    // ...
    default:
      self.font = UIFont.systemFontOfSize(19)
    }
  }
}
