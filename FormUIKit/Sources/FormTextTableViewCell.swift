//
//  FormTextTableViewCell.swift
//  ShopClothes
//
//  Created by Sahand on 9/28/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit
import SnapKit

struct FormTextDescription: FormFieldDescribable {
    
    enum FormTextValidationTypes {
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
    
    var tag: String
    var title: String
    
    var configureCell: ((FormTextTableViewCell) -> Void)? = nil
    
    var validateCell: ((FormTextTableViewCell, FormValues) -> Void)? = { cell, values in
        if let string = values[cell.formTextDescription!.tag] as? String, string.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0 {
            cell.titleLabel.textColor = .red
        } else {
            cell.titleLabel.textColor = cell.textField.isFirstResponder ? cell.tintColor : UIColor.black
        }
    }
    
    func isValid(_ values: FormValues) -> Bool {
        let invalids = validations.filter { !$0.isValid(self, values) }
        if invalids.count > 0 {
            return false
        }
        
        return true
    }
    
    var validations: Set<FormTextValidationTypes> = []
    
    init(tag: String, title: String) {
        self.tag = tag
        self.title = title
    }
}

class FormTextTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var formTextDescription: FormTextDescription? = nil
    weak var formTableViewController: FormTableViewController? = nil
    
    var layoutComplete = false
    var titleLabel = UILabel()
    var textField = UITextField()
    
    func set(for description: FormTextDescription, value: Any?) {
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
    
    private func resetCell() {
        titleLabel.text = ""
        textField.text = ""
        
        titleLabel.textColor = .black
        textField.textColor = .black
        
        textField.textAlignment = .left
        textField.placeholder = ""
        
        textField.keyboardType = .default
        textField.isSecureTextEntry = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel.textColor = tintColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        formTableViewController?.validateIfNeededFrom(self)
    }
    
    @objc func textFieldDidChange() {
        formTableViewController?.updateValueFrom(self, to: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let view = formTableViewController?.canGoToNextFrom(self) {
            view.becomeFirstResponder()
        }
        return true
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        textField.becomeFirstResponder()
        return true
    }
}
