//
//  FormFieldType.swift
//  ShopClothes
//
//  Created by Sahand on 9/28/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import UIKit

enum FormFieldType {
    case text(FormTextDescription), button(FormButtonDescription)
    
    var description: FormFieldDescribable {
        switch self {
        case .text(let description):
            return description
        case .button(let description):
            return description
        }
    }
}
