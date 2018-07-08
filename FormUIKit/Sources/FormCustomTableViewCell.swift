//
//  FormCustomDescription.swift
//  FormUIKit
//
//  Created by Sahand on 7/8/18.
//  Copyright © 2018 Sahand. All rights reserved.
//

import Foundation
import UIKit

public protocol FormCustomFieldDescribable: FormFieldDescribable {
    var cellIdentifier: String { get set }
    var configureCell: ((FormCustomTableViewCell) -> Void)? { get }
    var validateCell: ((Bool, Bool, FormCustomTableViewCell) -> Void)? { get }
}

public struct FormCustomDescription: FormCustomFieldDescribable {
    public var tag: String
    
    public var cellIdentifier: String
    public var configureCell: ((FormCustomTableViewCell) -> Void)?
    public var validateCell: ((Bool, Bool, FormCustomTableViewCell) -> Void)?
    
    public init(tag: String, cellIdentifier: String) {
        self.tag = tag
        self.cellIdentifier = cellIdentifier
    }
}

open class FormCustomTableViewCell: UITableViewCell {
    open var formCustomDescription: FormCustomFieldDescribable? = nil
    
    open var layoutComplete = false
    
    open func set(for description: FormCustomFieldDescribable, value: Any?) {}
    
    open func resetCell() {}
}

