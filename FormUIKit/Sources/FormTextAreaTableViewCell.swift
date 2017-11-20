//
//  FormTextAreaTableViewCell.swift
//  FormUIKit
//
//  Created by Sahand on 11/20/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

public struct FormTextAreaDescription: FormFieldDescribable {
    
    public var tag: String
    public var title: String
    
    public var textViewHeight: CGFloat = 400
    
    public var configureCell: ((FormTextAreaTableViewCell) -> Void)? = nil
    
    public var valdidateCell: ((Bool, Bool, FormTextAreaTableViewCell) -> Void)? = nil
    
    public init(tag: String, title: String) {
        self.tag = tag
        self.title = title
    }
}

open class FormTextAreaTableViewCell: UITableViewCell, UITextViewDelegate {
    
    open var formTextAreaDescription: FormTextAreaDescription? = nil
    open weak var formTableViewController: FormTableViewController? = nil
    
    open var layoutComplete = false
    open var titleLabel = UILabel()
    open var textView = UITextView()
    
    open func set(for description: FormTextAreaDescription, value: Any?) {
        formTextAreaDescription = description
        
        if !layoutComplete {
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(contentView.snp.leadingMargin)
                make.top.equalTo(13)
//                make.bottom.equalTo(-13)
            }
            
            titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
            titleLabel.adjustsFontForContentSizeCategory = true
            titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
            
            contentView.addSubview(textView)
            textView.snp.makeConstraints { make in
                make.leading.equalTo(titleLabel.snp.leading)
                make.trailing.equalTo(contentView.snp.trailingMargin)
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.bottom.equalTo(contentView).offset(-13)
                make.height.equalTo(description.textViewHeight)
            }
            
            textView.font = UIFont.preferredFont(forTextStyle: .body)
            textView.textContainerInset = UIEdgeInsets.zero
            textView.textContainer.lineFragmentPadding = 0
            
            selectionStyle = .none
            
            layoutComplete = true
        }
        
        titleLabel.text = description.title
        textView.text = value as? String
        textView.delegate = self
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        titleLabel.textColor = tintColor
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        formTableViewController?.validateIfNeededFrom(self)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        formTableViewController?.updateValueFrom(self, to: textView.text)
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        textView.becomeFirstResponder()
        return true
    }
}
