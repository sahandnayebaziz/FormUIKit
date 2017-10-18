//
//  FormButtonTableViewCell.swift
//  ShopClothes
//
//  Created by Sahand on 9/28/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

struct FormButtonDescription: FormFieldDescribable {
    var tag: String
    var title: String
    
    var didTapButton: ((FormButtonTableViewCell) -> Void)? = nil
    
    var configureCell: ((FormButtonTableViewCell) -> Void)? = nil
    
    var isValid: ((FormValues) -> Bool) = { _ in return true }
    
    init(tag: String, title: String) {
        self.tag = tag
        self.title = title
    }
}

class FormButtonTableViewCell: UITableViewCell {
    
    var formButtonDescription: FormButtonDescription? = nil
    weak var formTableViewController: FormTableViewController? = nil
    
    var layoutComplete = false
    var button = UIButton(type: .system)
    
    func set(for description: FormButtonDescription) {
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
    
    @objc func didTapButton() {
        formButtonDescription?.didTapButton?(self)
    }

}
