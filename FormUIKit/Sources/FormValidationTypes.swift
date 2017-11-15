//
//  FormValidationTypes.swift
//  FormUIKit
//
//  Created by Sahand on 11/14/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import Foundation

public enum FormValidationTypes: String {
    case tagNotNil, tagNotNilOrEmptyString
    
    func isValid(_ description: FormFieldDescribable, _ values: FormValues) -> Bool {
        switch self {
        case .tagNotNil:
            return values[description.tag] != nil
        case .tagNotNilOrEmptyString:
            guard let string = values[description.tag] as? String, string.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
                return false
            }
            return true
        }
    }
}
