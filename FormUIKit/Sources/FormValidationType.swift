//
//  FormValidationType.swift
//  FormUIKit
//
//  Created by Sahand on 11/14/17.
//  Copyright © 2017 Sahand. All rights reserved.
//

import Foundation

public enum FormValidationType: String {
    case tagNotNil, tagNotNilOrEmptyString
    
    func isValidFor(_ tag: String, in values: FormValues) -> Bool {
        switch self {
        case .tagNotNil:
            return values[tag] != nil
        case .tagNotNilOrEmptyString:
            guard let string = values[tag] as? String, string.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
                return false
            }
            return true
        }
    }
}