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

  @IBInspectable public var label: String? {
    didSet {
      textLabel.text = label
      configureLayout()
    }
  }

  @IBInspectable public var value: String? {
    didSet {
      textField.text = value
      configureLayout()
    }
  }

  public let textField = UITextField()
  public let textLabel = UILabel()

  // MARK - Lifecyle

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureSubviews()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    configureSubviews()
  }

  public override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.clearColor()
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

  private func configureLayout() {

    let editing = textField.isFirstResponder()

    if editing {
      textLabel.textColor = tintColor
    }
    else {
      textLabel.textColor = UIColor.lightGrayColor()
    }

    // If the field has text we always show both
    if let text = textField.text where !text.isEmpty {

      //textLabel.transform = CGAffineTransformMakeScale(0.7, 0.7)

      textFieldVerticalCenterConstraint?.active = false
      textLabelVerticalCenterConstraint?.active = false

      textFieldVerticalMarginConstraint?.active = true
      textLabelVerticalMarginConstraint?.active = true

      verticalSpacingConstraint?.active = true


    }
    // Otherwise we only show the label centered
    else {
//      if (editing) {
//        textLabel.transform = CGAffineTransformMakeScale(0.7, 0.7)
//      }

      textFieldVerticalCenterConstraint?.active = !editing
      textLabelVerticalCenterConstraint?.active = !editing

      textFieldVerticalMarginConstraint?.active = editing
      textLabelVerticalMarginConstraint?.active = editing

      verticalSpacingConstraint?.active = editing

      // textField.alpha = editing ? 1.0 : 0.0


    }

    invalidateIntrinsicContentSize()
    layoutIfNeeded()
  }

  private var textFieldVerticalCenterConstraint: NSLayoutConstraint?
  private var textLabelVerticalCenterConstraint: NSLayoutConstraint?

  private var textFieldVerticalMarginConstraint: NSLayoutConstraint?
  private var textLabelVerticalMarginConstraint: NSLayoutConstraint?

  private var verticalSpacingConstraint: NSLayoutConstraint?

  private func configureSubviews() {

    textLabel.font = UIFont.systemFontOfSize(12)
    textField.font = UIFont.systemFontOfSize(17)

    guard textField.superview == nil && textLabel.superview == nil else { return }

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

    configureLayout()
  }
}

extension FloatingLabelTextField: UITextFieldDelegate {

  private func animateTransition() {
    UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.7, options: [.AllowUserInteraction, .BeginFromCurrentState],
      animations: {
        self.configureLayout()
      },
      completion: { completed in

    })
  }

  public func textFieldDidBeginEditing(textField: UITextField) {
    animateTransition()
  }

  public func textFieldDidEndEditing(textField: UITextField) {
    animateTransition()
  }
}
