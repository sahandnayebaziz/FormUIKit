//
//  FormTextTableViewCell.swift
//  ShopClothes
//
//  Created by Sahand on 9/28/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit
import SnapKit

public struct FormTextDescription: FormFieldDescribable {
    
    public enum FormTextValidationTypes {
        case tagNotEmptyString
        
        func isValid(_ description: FormTextDescription, _ values: FormValues) -> Bool {
            switch self {
            case .tagNotEmptyString:
                guard let string = values[description.tag] as? String, string.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 else {
                    return false
                }
                return true
            }
        }
    }
    
    public var tag: String
    public var title: String
    
    public var configureCell: ((FormTextTableViewCell) -> Void)? = nil
    
    public var validateCell: ((FormTextTableViewCell, FormValues) -> Void)? = { cell, values in
        if let string = values[cell.formTextDescription!.tag] as? String, string.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            cell.titleLabel.textColor = .red
        } else {
            cell.titleLabel.textColor = cell.textField.isFirstResponder ? cell.tintColor : UIColor.black
        }
    }
    
    public func isValid(_ values: FormValues) -> Bool {
        let invalids = validations.filter { !$0.isValid(self, values) }
        if invalids.count > 0 {
            return false
        }
        
        return true
    }
    
    public var validations: Set<FormTextValidationTypes> = []
    
    public init(tag: String, title: String) {
        self.tag = tag
        self.title = title
    }
}

open class FormTextTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    open var formTextDescription: FormTextDescription? = nil
    open weak var formTableViewController: FormTableViewController? = nil
    
    open var layoutComplete = false
    open var titleLabel = UILabel()
    open var textField = UITextField()
    
    open func set(for description: FormTextDescription, value: Any?) {
        formTextDescription = description
        resetCell()
        if !layoutComplete {
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(contentView.snp.leadingMargin)
                make.top.equalTo(13)
                make.bottom.equalTo(-13)
            }
            
            titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
            titleLabel.adjustsFontForContentSizeCategory = true
            titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
            
            textField = UITextField()
            contentView.addSubview(textField)
            textField.snp.makeConstraints { make in
                make.leading.equalTo(titleLabel.snp.trailing).offset(8)
                make.trailing.equalTo(contentView.snp.trailingMargin)
                make.top.equalTo(contentView)
                make.bottom.equalTo(contentView)
            }
            
            textField.font = UIFont.preferredFont(forTextStyle: .body)
            textField.adjustsFontForContentSizeCategory = true
            textField.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            
            layoutComplete = true
        }
        
        titleLabel.text = description.title
        if let value = value as? String {
            textField.text = value
        }
        
        selectionStyle = .none
    }
    
    open func resetCell() {
        titleLabel.text = ""
        textField.text = ""
        
        titleLabel.textColor = .black
        textField.textColor = .black
        
        textField.textAlignment = .left
        textField.placeholder = ""
        
        textField.keyboardType = .default
        textField.isSecureTextEntry = false
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel.textColor = tintColor
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        formTableViewController?.validateIfNeededFrom(self)
    }
    
    @objc open func textFieldDidChange() {
        formTableViewController?.updateValueFrom(self, to: textField.text!)
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let view = formTableViewController?.canGoToNextFrom(self) {
            view.becomeFirstResponder()
        }
        return true
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        textField.becomeFirstResponder()
        return true
    }
}
