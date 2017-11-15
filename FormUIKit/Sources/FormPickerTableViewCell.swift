//
//  FormPickerTableViewCell.swift
//  FormUIKit
//
//  Created by Sahand on 11/12/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

struct FormPickableItem {
    var title: String
    var value: Any
}

public struct FormPickerDescription: FormFieldDescribable {
    public var tag: String
    public var title: String
    
    public var dataSourceForPicker: (() -> UIPickerViewDataSource)? = nil
    
    public var pickerRowTitleForRow: ((_ row: Int, _ component: Int) -> String)? = nil
    public var textFieldTitleForRow: ((_ row: Int, _ component: Int) -> String)? = nil
    public var valueForRow: ((_ row: Int, _ component: Int) -> Any)? = nil
    
    public var configureCell: ((FormPickerTableViewCell) -> Void)? = nil
    
    public var validateCell: ((FormPickerTableViewCell, FormValues) -> Void)? = nil
    
    public func isValid(_ values: FormValues) -> Bool {
        let invalids = validations.filter { !$0.isValid(self, values) }
        if invalids.count > 0 {
            return false
        }
        
        return true
    }
    
    public var validations: Set<FormValidationTypes> = []
    
    public init(tag: String, title: String) {
        self.tag = tag
        self.title = title
    }
}

public class FormPickerTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate {
    
    open var formPickerDescription: FormPickerDescription? = nil
    open weak var formTableViewController: FormTableViewController? = nil
    
    open var layoutComplete = false
    open var titleLabel = UILabel()
    open var textField = UITextField()
    open var picker = UIPickerView()
    
    open func set(for description: FormPickerDescription, value: Any?) {
        formPickerDescription = description
        resetCell()
        if !layoutComplete {
            selectionStyle = .none
            
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
            textField.inputView = picker
            
            layoutComplete = true
        }
        
        titleLabel.text = description.title
        if let value = value as? String {
            textField.text = value
        }
        
        guard let dataSource = description.dataSourceForPicker?() else {
            fatalError("No data source for picker cell")
        }
        picker.dataSource = dataSource
        picker.delegate = self
        
        guard let _ = description.pickerRowTitleForRow else {
            fatalError("No pickerRowTitleForRow function")
        }
        
        guard let _ = description.textFieldTitleForRow else {
            fatalError("No pickerRowTitleForRow function")
        }
        
        guard let _ = description.valueForRow else {
            fatalError("No valueForRow function")
        }
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
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        textField.becomeFirstResponder()
        return true
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let textFieldTitle = formPickerDescription?.textFieldTitleForRow?(row, component),
            let value = formPickerDescription?.valueForRow?(row, component) else {
                fatalError("Could not manage getting title and value after picker row selection.")
        }
        
        textField.text = textFieldTitle
        formTableViewController?.updateValueFrom(self, to: value)
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formPickerDescription?.pickerRowTitleForRow?(row, component)
    }
    
}
