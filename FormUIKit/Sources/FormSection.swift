//
//  FormSection.swift
//  ShopClothes
//
//  Created by Sahand on 9/28/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

public struct FormSection {
    public var header: String?
    public var footer: String?
    public var fields: [FormFieldType]
    
    public init() {
        self.header = nil
        self.footer = nil
        self.fields = []
    }
    
    public init(header: String?, footer: String?, fields: [FormFieldType]) {
        self.header = header
        self.footer = footer
        self.fields = fields
    }
}
