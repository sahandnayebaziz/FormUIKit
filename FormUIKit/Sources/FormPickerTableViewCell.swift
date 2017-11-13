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
    public var valueForPickerSelection: ((_ row: Int, _ component: Int) -> Any)? = nil
    
    public var configureCell: ((FormPickerTableViewCell) -> Void)? = nil
    
    public var validateCell: ((FormPickerTableViewCell, FormValues) -> Void)? = nil
    
    public var isValid: ((FormValues) -> Bool) = { _ in
        // TODO: implement like text cell
        return true
    }
    
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
        
        if description.dataSourceForPicker != nil && description.valueForPickerSelection != nil {
            picker.dataSource = description.dataSourceForPicker!()
            textField.inputView = picker
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
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = pickerView.delegate?.pickerView(pickerView, titleForRow: row, forComponent: component)
    }

}
