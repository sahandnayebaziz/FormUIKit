//
//  FormSection.swift
//  ShopClothes
//
//  Created by Sahand on 9/28/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

struct FormSection {
    var header: String?
    var footer: String?
    var fields: [FormFieldType]
    
    init() {
        self.header = nil
        self.footer = nil
        self.fields = []
    }
    
    init(header: String?, footer: String?, fields: [FormFieldType]) {
        self.header = header
        self.footer = footer
        self.fields = fields
    }
}
