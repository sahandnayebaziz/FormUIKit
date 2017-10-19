//
//  FormButtonTableViewCell.swift
//  ShopClothes
//
//  Created by Sahand on 9/28/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

public struct FormButtonDescription: FormFieldDescribable {
    public var tag: String
    public var title: String
    
    public var didTapButton: ((FormButtonTableViewCell) -> Void)? = nil
    
    public var configureCell: ((FormButtonTableViewCell) -> Void)? = nil
    
    public var isValid: ((FormValues) -> Bool) = { _ in return true }
    
    public init(tag: String, title: String) {
        self.tag = tag
        self.title = title
    }
}

public class FormButtonTableViewCell: UITableViewCell {
    
    open var formButtonDescription: FormButtonDescription? = nil
    weak open var formTableViewController: FormTableViewController? = nil
    
    open var layoutComplete = false
    open var button = UIButton(type: .system)
    
    open func set(for description: FormButtonDescription) {
        formButtonDescription = description
        if !layoutComplete {
            contentView.addSubview(button)
            button.snp.makeConstraints { make in
                make.leading.equalTo(contentView.snp.leadingMargin)
                make.trailing.equalTo(contentView.snp.trailingMargin)
                make.top.equalTo(13)
                make.bottom.equalTo(-13)
            }
            layoutComplete = true
        }
        
        button.setTitle(description.title, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.titleLabel!.adjustsFontForContentSizeCategory = true
        button.titleLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(formTableViewController!.view.tintColor, for: .normal)
        selectionStyle = .none
    }
    
    @objc open  func didTapButton() {
        formButtonDescription?.didTapButton?(self)
    }

}
