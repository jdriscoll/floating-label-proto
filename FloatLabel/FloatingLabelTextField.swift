//
//  FloatingLabelTextField.swift
//  FloatLabel
//
//  Created by Justin Driscoll on 2/3/16.
//  Copyright © 2016 Justin Driscoll. All rights reserved.
//

import UIKit

public class FloatingLabelTextField: UIView {

  // MARK - Interface

  @IBInspectable public var label: String?
  @IBInspectable public var value: String?

  @IBInspectable public var active: Bool = false {
    didSet {
      self.configureConstraints()
      if active {
        textLabel.textColor = self.tintColor
      }
      else {
        textLabel.textColor = UIColor.lightGrayColor()
      }
    }
  }

  public let textField = UITextField()
  public let textLabel = UILabel()

  // MARK - Lifecyle

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureSubviews()
    textLabel.font = UIFont.systemFontOfSize(12)
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    configureSubviews()
  }

  public override func awakeFromNib() {
    super.awakeFromNib()

    textLabel.text = label
    textField.placeholder = label
    textField.text = value

    if active { textField.becomeFirstResponder() }
  }

  public override func intrinsicContentSize() -> CGSize {
    guard let topMargin = textLabelVerticalMarginConstraint?.constant,
      let bottomMargin = textFieldVerticalMarginConstraint?.constant,
      let spacing = verticalSpacingConstraint?.constant else {
        return CGSizeZero
    }

    let width = max(textField.intrinsicContentSize().width, textLabel.intrinsicContentSize().width)
    let height = [textLabel.intrinsicContentSize().height, textField.intrinsicContentSize().height, topMargin, bottomMargin, spacing].reduce(0, combine: +)

    return CGSize(width: width, height: height)
  }

  // MARK - Internal

  private var editing: Bool {
    return self.textField.isFirstResponder()
  }

  private func setEditing(isEditing: Bool, animated: Bool = false) {

    if (animated) {
      UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: [.AllowUserInteraction, .BeginFromCurrentState],
        animations: {
          self.configureConstraints()
          self.textLabel.alpha = self.editing ? 1 : 0
          self.active = self.editing
        },
        completion: { completed in

      })
    }
    else {
      configureConstraints()
      layoutIfNeeded()
      textLabel.alpha = self.editing ? 1 : 0
      active = editing
    }
  }

  private func configureConstraints() {
    textFieldVerticalCenterConstraint?.active = !self.editing
    textLabelVerticalCenterConstraint?.active = !self.editing

    textFieldVerticalMarginConstraint?.active = self.editing
    textLabelVerticalMarginConstraint?.active = self.editing

    verticalSpacingConstraint?.active = self.editing

    invalidateIntrinsicContentSize()
    layoutIfNeeded()
  }

  private var textFieldVerticalCenterConstraint: NSLayoutConstraint?
  private var textLabelVerticalCenterConstraint: NSLayoutConstraint?

  private var textFieldVerticalMarginConstraint: NSLayoutConstraint?
  private var textLabelVerticalMarginConstraint: NSLayoutConstraint?

  private var verticalSpacingConstraint: NSLayoutConstraint?

  private func configureSubviews() {

    guard textField.superview == nil && textLabel.superview == nil else { return }

    textLabel.userInteractionEnabled = false

    textField.delegate = self

    textField.translatesAutoresizingMaskIntoConstraints = false
    textLabel.translatesAutoresizingMaskIntoConstraints = false

    addSubview(textField)
    addSubview(textLabel)

    let views = ["field": textField, "label": textLabel]

    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[field]|", options: .AlignAllBaseline, metrics: nil, views: views))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: .AlignAllBaseline, metrics: nil, views: views))

    // Vertical center constraints
    textFieldVerticalCenterConstraint = NSLayoutConstraint(item: textField, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)
    textLabelVerticalCenterConstraint = NSLayoutConstraint(item: textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0)

    // Vertical margin constraints
    textFieldVerticalMarginConstraint = NSLayoutConstraint(item: textField, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
    textLabelVerticalMarginConstraint = NSLayoutConstraint(item: textLabel, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)

    verticalSpacingConstraint = NSLayoutConstraint(item: textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: textField, attribute: .Top, multiplier: 1, constant: 4)

    addConstraints([textFieldVerticalCenterConstraint!, textLabelVerticalCenterConstraint!, textFieldVerticalMarginConstraint!, textLabelVerticalMarginConstraint!, verticalSpacingConstraint!])

    setEditing(false)
  }
}

extension FloatingLabelTextField: UITextFieldDelegate {

  public func textFieldDidBeginEditing(textField: UITextField) {
    setEditing(true, animated: true)
  }

  public func textFieldDidEndEditing(textField: UITextField) {
    setEditing(false, animated: true)
  }
}
